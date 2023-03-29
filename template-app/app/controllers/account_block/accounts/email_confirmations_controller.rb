# frozen_string_literal: true

module AccountBlock
  module Accounts
    class EmailConfirmationsController < ApplicationController
      include BuilderJsonWebToken::JsonWebTokenValidation

      before_action :validate_json_web_token

      def show
        begin
          @account = EmailAccount.find(@token.id)
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {account: "Account Not Found"}
          ]}, status: :unprocessable_entity
        end

        if @account.activated?
          return render json: ValidateAvailableSerializer.new(@account, meta: {
            message: "Account Already Activated"
          }).serializable_hash, status: :ok
        end

        @account.update activated: true
        redirect_to "secretfriend://login?token=#{encoded_token}", allow_other_host: true and return
      end

      private

      def encoded_token
        BuilderJsonWebToken.encode @account.id, 7.days.from_now
      end
    end
  end
end
