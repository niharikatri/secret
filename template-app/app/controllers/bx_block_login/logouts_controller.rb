module BxBlockLogin
  class LogoutsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    def destroy
      header_token = request.headers[:token]
      if header_token.present?
        begin
          @token = BuilderJsonWebToken.decode(header_token)
          @current_user = AccountBlock::Account.find(@token.id)
          token = encoded_token
              render json: {
                      message: "Logout Successfully..",
                account: AccountBlock::AccountSerializer.new(@current_user),
                token: token
            }

        rescue JWT::DecodeError => e
          return render json: {
            errors: [{
              token: 'Invalid token',
            }],
          }, status: :bad_request
        end
      else
        render json: {message: "Token Required"}
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @token.id, Time.now
    end
  end
end
