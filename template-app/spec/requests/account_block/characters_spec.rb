require 'rails_helper'

RSpec.describe "AccountBlock::Characters", type: :request do
  describe "GET /index" do
  	it "Gives out list of all the voices added" do 
  		get '/account_block/characters'
  		data = JSON.parse(response.body)
  		expect(response).to have_http_status(200)
  	end
  end
end
