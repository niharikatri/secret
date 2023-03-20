module BxBlockForgotPassword
  class EmailOtpMailer < ApplicationMailer
    def otp_email
      @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @otp.email,
          from: 'fmrabie@hotmail.com',
          subject: 'Your OTP code') do |format|
        format.html { render 'otp_email' }
      end
    end
  end
end
