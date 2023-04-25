require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::PrivacyPoliciesController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @privacy_policy = FactoryBot.create(:privacy_policy)
    sign_in @admin
  end
 
  describe "Get#index" do
    it "show all data" do
      get :index
      expect(response).to have_http_status(200)
    end
  end
  describe "Get#show" do
    it "show privacy_policy details" do
      get :show, params: {id: @privacy_policy.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        description: "privacy_policy"
    }
    end
    it "edit privacy_policy" do
        put :edit, params: {id: @privacy_policy.id, privacy_policy: params}
        expect(response).to have_http_status(200)
    end
  end
end