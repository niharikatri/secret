module BxBlockForgotPassword
  class PasswordsController < ApplicationController
    def create
      if create_params[:token].present? && create_params[:new_password].present?
        # Try to decode token with OTP information
        begin
          token = BuilderJsonWebToken.decode(create_params[:token])
        rescue JWT::DecodeError => e
          return render json: {
            errors: [{
              token: 'Invalid token',
            }],
          }, status: :bad_request
        end

        # Try to get OTP object from token
        begin
          otp = token.type.constantize.find(token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {
            errors: [{
              otp: 'Token invalid',
            }],
          }, status: :unprocessable_entity
        end

        # Check if OTP was validated
        unless otp.activated?
          return render json: {
            errors: [{
              otp: 'OTP code not validated',
            }],
          }, status: :unprocessable_entity
        else
          # Check new password requirements
          password_validation = AccountBlock::PasswordValidation
            .new(create_params[:new_password])

          is_valid = password_validation.valid?
          error_message = password_validation.errors.full_messages.first

          unless is_valid
            return render json: {
              errors: [{
                password: error_message,
              }],
            }, status: :unprocessable_entity
          else
            # Update account with new password
            account = AccountBlock::Account.find(token.account_id)

            if account.update(:password => create_params[:new_password])
              # Delete OTP object as it's not needed anymore
              otp.destroy

              serializer = AccountBlock::AccountSerializer.new(account)
              serialized_account = serializer.serializable_hash

              render json: serialized_account, status: :created
            else
              render json: {
                errors: [{
                  profile: 'Password change failed',
                }],
              }, status: :unprocessable_entity
            end
          end
        end
      else
        return render json: {
          errors: [{
            otp: 'Token and new password are required',
          }],
        }, status: :unprocessable_entity
      end
    end

    def create_password
      if params[:new_password].present? && params[:token]
        begin
          token = BuilderJsonWebToken.decode params[:token]
        rescue
          return render json: { errors: [token: 'Token has Expired'] },
          status: :unprocessable_entity
        end

        @account = AccountBlock::Account.find_by(id: token.id)

        if @account.present? && @account.update_attribute(:password, params[:new_password])
            render json: { status: true, data: @account }
        else
            render json: { status: false }
        end
      else
        flash.now[:error] = 'Please fill all fields.'
      end
    end

    def generate_password_link
      if params[:data][:email].present?
        @account = AccountBlock::Account.where(email: params[:data][:email].downcase).last
        if @account.present?
          forgot_password_email_for(@account)
          render json: {
            success:'Password link was successfully sent to the registered mail. Please check your email' 
          }, status: :ok
        else
          render json: {
            errors:"Account not found." 
          }, status: :not_found
        end
      end
    end

    private

    def forgot_password_email_for account
      BxBlockForgotPassword::ForgotPasswordMailer
        .with(host: request.base_url)
        .forgot_password_email(account).deliver
    end

    def create_params
      params.require(:data)
        .permit(*[
          :email,
          :full_phone_number,
          :token,
          :otp_code,
          :new_password,
        ])
    end
  end
end
