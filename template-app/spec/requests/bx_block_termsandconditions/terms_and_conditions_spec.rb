require 'rails_helper'

RSpec.describe "BxBlockTermsandconditions::TermsAndConditions", type: :request do
  before do |example|
      @terms = FactoryBot.create(:terms)
      @path = '/bx_block_termsandconditions/terms_and_conditions'
    end
  describe "GET /index" do
    it 'returns successful response' do
      get @path
      expect(response).to have_http_status(200)
    end
    it 'returns successful response' do
      get @path, params:{ token: @headers}
      response_json = JSON.parse(response.body)
      expect(response_json).not_to be_nil
    end

    it 'returns successful response data nil' do
      @terms.destroy
      get @path, params:{ token: @headers}
      expect(response).to have_http_status(404)
      response_json = JSON.parse(response.body)
      expect(response_json).to eq("message"=>"Terms and Conditions not found")
    end
  end
end
