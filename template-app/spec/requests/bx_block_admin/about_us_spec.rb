require 'rails_helper'

RSpec.describe "BxBlockAdmin::AboutUs", type: :request do
  before do |example|
      @about_us = FactoryBot.create(:about_us)
      @path = '/bx_block_admin/about_us'
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
      BxBlockAdmin::AboutUs.destroy_all
      get @path, params:{ token: @headers}
      expect(response).to have_http_status(404)
      response_json = JSON.parse(response.body)
      expect(response_json).to eq("message"=>"About Us not found")
    end
  end
end

