require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::LanguagesController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @language = FactoryBot.create(:language)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        description:"language"
    }
    end
    it "create language " do
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
    it "show language details" do
      get :show, params: {id: @language.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        description: "language"
    }
    end
    it "edit language" do
        put :edit, params: {id: @language.id, language: params}
        expect(response).to have_http_status(200)
    end
  end
end