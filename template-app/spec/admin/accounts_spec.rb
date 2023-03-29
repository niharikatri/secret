require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::AccountsController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @account = FactoryBot.create(:account)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        name: "Test",
        image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/test_image.gif'))
    }
    end
    it "create accounts " do
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
    it "show accounts details" do
      get :show, params: {id: @account.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        name: "accounts"

    }
    end
    it "edit account" do
        put :edit, params: {id: @account.id, terms: params}
        expect(response).to have_http_status(200)
    end
  end
end