module AccountBlock
  class AccountsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:search, :change_email_address, :change_phone_number, :specific_account, :logged_user, :update, :update_profile_pic]

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
      account_params = jsonapi_deserialize(params)
      if @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      end
    end

    def update_profile_pic
      @account = Account.find(@token.id)
      if @account.update(account_params)
        render json: AccountSerializer.new(@account).serializable_hash, status: :ok
      end
    end


    def user_roles_and_name
      account_id = BuilderJsonWebToken::JsonWebToken.decode(params[:token]).id
      @account = AccountBlock::Account.find(account_id)
      @account.update(role_id: params[:role_id], first_name: params[:name]) 
      @account.save
      if @account.role_id.present? && @account.first_name.present?
        render json: {status: 'success', message:'Role and Name is updated.'}, status: :ok
      else
        render json: {status: 'error', message:'Missing Content'}, status: :unprocessable_entity
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
