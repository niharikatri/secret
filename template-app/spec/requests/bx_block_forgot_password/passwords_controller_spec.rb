require 'rails_helper'
require 'spec_helper'

RSpec.describe BxBlockForgotPassword::PasswordsController, type: :request do
  #let(:account){FactoryBot.create(:account,email: "test@example.com")}
  VAR="/bx_block_forgot_password/generate_password_link"
  VAR1= "/bx_block_forgot_password/create_password"
  before(:each) do
    @email_account = FactoryBot.create(:account)
    @token = BuilderJsonWebToken.encode(@email_account.id)
  end

  describe "GET /generate_password_link" do
    context 'when there is a request to forgot password generate' do
      it 'When password link successfully generate' do
        get VAR, params: { data: { email: @email_account.email,activated: true }, :format => 'js' }
        expect(response.status).to eq 200
      end
     
      it "When password link successfully generate" do
        get VAR, params: { data: { email: @email_account.email }, :format => 'js' }
      end
     
      it "When password not" do
        get VAR, params: { data: { email: "nil_data@yopmail.com" }  }
        expect(response.status).to eq 404
      end  
    end
  end

  describe "PUT /create_password" do
    context 'reset password' do
      it 'create new password through link' do
        put VAR1, params: { new_password: "test@123" ,token: @token }
        expect(response.status).to eq 200
      end
      
      it 'when token is invalid' do
        put VAR1, params: { new_password: "test@123" ,token: ".." }
        expect(response.status).to eq 422
      end

      it 'when new password is nil' do
        put VAR1, params: { new_password: nil }
        expect(response.status).to eq 204
      end
    end
  end
end