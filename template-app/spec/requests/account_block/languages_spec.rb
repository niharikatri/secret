require 'rails_helper'

RSpec.describe "AccountBlock::Languages", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/account_block/languages/"
      expect(response).to have_http_status(:success)
    end
  end

end
