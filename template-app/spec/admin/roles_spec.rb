require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::RolesController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @role = FactoryBot.create(:role)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        description:"role"
    }
    end
    it "create role " do
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
    it "show role details" do
      get :show, params: {id: @role.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        description: "role"
    }
    end
    it "edit role" do
        put :edit, params: {id: @role.id, role: params}
        expect(response).to have_http_status(200)
    end
  end
end