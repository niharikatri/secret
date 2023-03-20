require 'rails_helper'

RSpec.describe "BxBlockAdmin::HowWeWorks", type: :request do
  before do |example|
      @how_we_work = FactoryBot.create(:how_we_work)
      @path = '/bx_block_admin/how_we_works'
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
      BxBlockAdmin::HowWeWork.destroy_all
      get @path, params:{ token: @headers}
      expect(response).to have_http_status(404)
      response_json = JSON.parse(response.body)
      expect(response_json).to eq("message"=>"How We Work not found")
    end
  end
end
