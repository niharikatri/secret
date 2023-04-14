require "rails_helper"

RSpec.describe BxBlockAudiovideomessenger::Conversation, type: :request do
  ROUTES = "/bx_block_audiovideomessenger/conversations"
  before(:each) do
    @account = FactoryBot.create(:account)
    @token = BuilderJsonWebToken.encode(@account.id)
  end

  describe "Creates when params is present" do
    context "it creates" do
      it "post create request" do
        post ROUTES , params: {account_ids: "1", token: @token, name: "demo"}
        expect(response).to have_http_status(201)
      end
    end
  end

  describe "list user accounts" do
    context "it shows users" do
      let(:conversation) { create(:conversation) }
      it "get index request" do
        get ROUTES , params: { token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end    
    
  describe "show one user" do
    context "it shows single user" do
      let(:conversation) { FactoryBot.create(:conversation) }
      let(:audio) { FactoryBot.create(:audio, conversation_id: conversation.id) }
      it "get index request" do
        get "/bx_block_audiovideomessenger/conversations/#{conversation.id}" , params: { token: @token}
        expect(response).to have_http_status(200)
      end
    end
  end  
end