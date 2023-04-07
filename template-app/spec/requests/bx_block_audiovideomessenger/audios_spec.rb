require "rails_helper"

RSpec.describe BxBlockAudiovideomessenger::Audio, type: :request do
  VARI="/bx_block_audiovideomessenger/audios"
  before(:each) do
    @account = FactoryBot.create(:account)
    @token = BuilderJsonWebToken.encode(@account.id)
  end
    
  describe "Creates when params is present" do
    context "it creates" do
      let(:audio) { create(:audio) }
      it "post create request" do
        post VARI , params: {conversation_id: "1", token: @token}
        expect(response).to have_http_status(201)
      end
    end
  end
end