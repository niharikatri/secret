require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::HowWeWorksController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @how_we_work = FactoryBot.create(:how_we_work)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        description:"how_we_work"
    }
    end
    it "create how_we_work " do
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
    it "show how_we_work details" do
      get :show, params: {id: @how_we_work.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        description: "how_we_work"

    }
    end
    it "edit how_we_work" do
        put :edit, params: {id: @how_we_work.id, how_we_work: params}
        expect(response).to have_http_status(200)
    end
  end
end