require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::AboutUsController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @about_us = FactoryBot.create(:about_us)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        description:"about_us"
    }
    end
    it "create about_us " do
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
    it "show about_us details" do
      get :show, params: {id: @about_us.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        description: "about_us"

    }
    end
    it "edit about_us" do
        put :edit, params: {id: @about_us.id, about_us: params}
        expect(response).to have_http_status(200)
    end
  end
end