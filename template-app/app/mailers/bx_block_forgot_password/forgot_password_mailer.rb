module BxBlockForgotPassword
  class ForgotPasswordMailer < ApplicationMailer
    def forgot_password_email(account)
      @account = account
      @url = "secretfriend://reset?token=#{encoded_token}"

      mail(
        to: @account.email,
        from: "fmrabie@hotmail.com",
        subject: "New Password Reset link"
      ) do |format|
        format.html { render "forgot_password_email" }
      end
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 7.days.from_now
    end
  end
end
