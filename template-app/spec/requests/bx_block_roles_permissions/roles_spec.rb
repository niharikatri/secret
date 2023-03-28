require 'rails_helper'

RSpec.describe "BxBlockRolesPermissions::Roles", type: :request do
	describe "GET /index" do
	  it "returns http success" do
	    get "/bx_block_roles_permissions/roles/"
	    expect(response).to have_http_status(:success)
	  end
	end
end
