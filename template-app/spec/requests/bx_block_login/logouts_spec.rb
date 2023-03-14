require 'rails_helper'

RSpec.describe "BxBlockLogin::Logouts", type: :request do
  describe "DELETE /destroy" do

    let!(:account) { FactoryBot.create(:account) }   
    before do
      @content_type = "application/json"
      @c_type = "Content-Type"
      auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
      @headers = {
        "token" => auth_token,
        @c_type => @content_type
      }
      @logout_path = "/bx_block_login/logouts/" + account.id.to_s
    end

    it "Logs account put" do 
      delete @logout_path, headers: @headers
      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response_json["message"]).to eq("Logout Successfully..")
    end

    it "Returns error" do 
      headers = {
        "token" => "asjfhalskhflaskjflkasjlfkjasf",
        @c_type => @content_type
      }
      delete @logout_path, headers: headers
      response_json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
    end

    it "Returns error" do 
      headers = {
        @c_type => @content_type
      }
      delete @logout_path, headers: headers
      response_json = JSON.parse(response.body)
      expect(response_json).to eq("message"=>"Token Required")
    end
  end
end
