require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::VoicesController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @voice = FactoryBot.create(:voice)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        name: "Test",
        audio: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/audio/test_audio.wav'))
    }
    end
    it "create voices " do
      post :new, params: params
      expect(response).to have_http_status(200)
    end
  end
  describe "Get#index" do
    it "show all data" do
      get :index
      expect(response).to have_http_status(200)
    end
  end
  describe "Get#show" do
    it "show voices details" do
      get :show, params: {id: @voice.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        name: "voices"

    }
    end
    it "edit voice" do
        put :edit, params: {id: @voice.id, terms: params}
        expect(response).to have_http_status(200)
    end
  end
end