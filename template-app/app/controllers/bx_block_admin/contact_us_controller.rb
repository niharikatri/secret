module BxBlockAdmin
  class ContactUsController < ApplicationController
    def create
      @contact_us = ContactUs.new(contact_params)
        if @contact_us.save
          render json: @contact_us, status: :created
        else
          render json: @contact_us.errors, status: :unprocessable_entity
        end
    end

    private

    def contact_params
      params.require(:contact_us).permit(:full_name, :email_address, :mobile_no, :message)
    end
  end
end
  