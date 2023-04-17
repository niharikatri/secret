require 'rails_helper'

RSpec.describe "BxBlockAdmin::ContactUs", type: :request do
  before do |example|
      @contact_us = FactoryBot.create(:contact_us)
      @path = '/bx_block_admin/contact_us'
    end
  describe "POST /create" do
    it 'returns successful response' do
      post @path, params: {contact_us: { full_name: "test",email_address: "test@example.com", mobile_no: 148552244,message:"hi" }}
      expect(response).to have_http_status(201)
    end
  end
end

