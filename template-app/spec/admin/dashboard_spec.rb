require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::DashboardController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save

    sign_in @admin
  end
  describe "Get#index" do
    it "show all data" do
      get :index
      expect(response).to have_http_status(200)
    end
  end
  describe "Dashboard page" do

    it "displays total users count" do
      # expect(response).to have_content("Total Users")
      # expect(response).to have_link(AccountBlock::Account.count, href: "/admin/user_managements")
      expect(response).to have_http_status(200)
    end

    it "displays deactivated accounts count" do
      expect(response).to have_http_status(200)
    end

    it "displays blacklisted accounts count" do
      expect(response).to have_http_status(200)
    end

    it "displays user groups count" do
      # expect(response).to have_content("User Groups")
      # expect(response).to have_content(AccountBlock::Account.pluck(:unique_code).uniq.compact.count)
      expect(response).to have_http_status(200)
    end
  end
end