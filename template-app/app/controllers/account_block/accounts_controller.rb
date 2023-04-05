module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:search, :change_email_address, :change_phone_number, :specific_account, :logged_user, :update, :update_profile_pic, :generate_unique_code, :verified_unique_code]

    def create
      case params[:data][:type] #### rescue invalid API format
      when "sms_account"
        validate_json_web_token

        unless valid_token?
          return render json: {errors: [
            {token: "Invalid Token"}
          ]}, status: :bad_request
        end

        begin
          @sms_otp = SmsOtp.find(@token[:id])
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: "Confirmed Phone Number was not found"}
          ]}, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          render json: SmsAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when "email_account"
        account_params = jsonapi_deserialize(params)

        query_email = account_params["email"].downcase
        account = EmailAccount.where("LOWER(email) = ?", query_email).first
        account.destroy if account&.activated == false

        validator = EmailValidation.new(account_params["email"])

        if !validator.valid?
          return render json: {errors: [
            {account: "Email invalid"}
          ]}, status: :unprocessable_entity
        end

        @account = EmailAccount.new(jsonapi_deserialize(params))
        @account.platform = request.headers["platform"].downcase if request.headers.include?("platform")

        if @account.save
          EmailValidationMailer
            .with(account: @account, host: request.base_url)
            .activation_email.deliver_now
          render json: EmailAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when "social_account"
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      else
        render json: {errors: [
          {account: "Invalid Account Type"}
        ]}, status: :unprocessable_entity
      end
    end

    def search
      @accounts = Account.where(activated: true)
        .where("first_name ILIKE :search OR " \
                           "last_name ILIKE :search OR " \
                           "email ILIKE :search", search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: {message: "List of users."}).serializable_hash, status: :ok
      else
        render json: {errors: [{message: "Not found any user."}]}, status: :ok
      end
    end

    def change_email_address
      query_email = params["email"]
      account = EmailAccount.where("LOWER(email) = ?", query_email).first

      validator = EmailValidation.new(query_email)

      if account || !validator.valid?
        return render json: {errors: "Email invalid"}, status: :unprocessable_entity
      end
      @account = Account.find(@token.id)
      if @account.update(email: query_email)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      else
        render json: {errors: "account user email id is not updated"}, status: :ok
      end
    end

    def change_phone_number
      @account = Account.find(@token.id)
      if @account.update(full_phone_number: params["full_phone_number"])
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      else
        render json: {errors: "account user phone_number is not updated"}, status: :ok
      end
    end

    def specific_account
      @account = Account.find(@token.id)
      if @account.present?
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      else
        render json: {errors: "account does not exist"}, status: :ok
      end
    end

    def index
      @accounts = Account.all
      if @accounts.present?
        render json: AccountSerializer.new(@accounts).serializable_hash, status: :ok
      else
        render json: {errors: "accounts data does not exist"}, status: :ok
      end
    end

    def logged_user
      @account = Account.find(@token.id)
      if @account.present?
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      else
        render json: {errors: "account does not exist"}, status: :ok
      end
    end

    def update
      @account = Account.find(@token.id)

      if @account.blank?
        render json: {status: "error", message: "account not found"}, status: :not_found and return
      end

      account_params = jsonapi_deserialize(params)

      if account_params.include?("equalizer_profile") && @account.role_id == BxBlockRolesPermissions::Role.find_by(name: "Child").id
        render json: {status: "error", message: "cannot update equalizer profile for child role"}, status: :forbidden and return
      end

      begin
        @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      rescue => e
        render json: {status: "error", message: e.message}, status: :bad_request
      end
    end

    def update_profile_pic
      @account = Account.find(@token.id)
      if @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      end
    end

    def generate_unique_code
      @account = Account.find(@token.id)
      role = BxBlockRolesPermissions::Role.find_by(name: "Parent1")
      if @account.present? && @account.role_id == role.id
        if @account.unique_code.blank?
          random_code = SecureRandom.random_number(100**5).to_s.rjust(10,'0')
          @account.update(unique_code: random_code)
          @account.save
        end
        return render json: { unique_code: @account.unique_code }, status: :ok
      end
      render json: { message: 'This is not the Parent1 user, not able to generate unique code!'}, status: :ok
    end

    def verified_unique_code
      @child_account = Account.find(@token.id)
      parent1_role_id = BxBlockRolesPermissions::Role.find_by(name: "Parent1").id
      account = Account.find_by(unique_code: params[:unique_code])
      if account.present?
        if @child_account.present? && @child_account.role_id != parent1_role_id
          if @child_account.unique_code.blank?
            @child_account.update(unique_code: params[:unique_code])
            @child_account.save
            return render json: { message: 'Code is verified Successfully!' }, status: 200
          end
          return render json: { message: 'User already verified!' }, status: 200
        end
        return render json: { errors: 'This is a Parent1 user,Verification failed!' }, status: :ok
      end
      render json: { errors: 'Wrong Unique Code!' }, status: :ok
    end
    
    def listing_user
      current_user_id = BuilderJsonWebToken::JsonWebToken.decode(params[:token]).id
      return render json: {errors: "please insert unique code"}, status: :not_found unless params[:unique_code].present?
      @account = AccountBlock::Account.where(unique_code: params[:unique_code]).where.not(id: current_user_id)
      if @account.present?
          render json: { status: 'success', child_accounts: @account}, status: :ok 
      else
          render json: {status: 'error', message:"child account not present"}, status: :not_found 
      end
    end

    private

    def account_params
      params.require(:account).permit(:profile_pic)
    end

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def search_params
      params.permit(:query)
    end

    def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << {attribute => error}
        end
        result
    end
  end
end
