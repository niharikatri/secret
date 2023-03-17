require 'rails_helper'

RSpec.describe AccountBlock::Account, type: :request do

    describe 'account_block/accounts' do

      let!(:account) { FactoryBot.create(:account) }   
      before do
        auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
        @headers = {
          "token" => auth_token,
          "Content-Type" => "application/json"
        }
        @post_path = "/account_block/accounts"
      end

      describe 'post #create' do
        let(:request_params) do
          {
           data: {
            type: "email_account",
            attributes: {
              email: "test1@gmail.com",
              password: "Test@123"
              
            }
          }
        }
      end

      it 'returns successful response' do
        post @post_path, {params: request_params}
        expect(response).to have_http_status(201)
      end

      it 'response is not nill' do
        post @post_path, {params: request_params}
        response_json = JSON.parse(response.body)
        expect(response_json).not_to be_nil
      end
      let(:create_params) do
          {
           data: {
            type: "email_account",
            attributes: {
              email: "test@gmail.com",
              password: "Test@123"
              
            }
          }
        }
      end

      it 'returns error when user already existed' do
        post @post_path, {params: create_params}
        response_json = JSON.parse(response.body)
        expect(response_json['errors']).to eq([{"email"=>"has already been taken"}])
      end
      it 'Invalid email' do
        post @post_path, params:{data:{type:"email_account",attributes:{ email: "12345", password:"Test1@12"}}}
        expect(response).to have_http_status(422)
      end

    end
   end



    describe "PUT update" do
      let(:create_params) do
          {
           data: {
            attributes: {
              voice_id: FactoryBot.create(:voice).id,
              character_id: FactoryBot.create(:character).id
              
            }
          }
        }
      end
      it "Updates the Account" do 
        account = FactoryBot.create(:account)
        token = BuilderJsonWebToken.encode(account.id)
        auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
        headers = {
          "token" => token,
          "Content-Type" => "application/json"
        }
        url = '/account_block/accounts/' + account.id.to_s
        put url, params: create_params.to_json, headers: headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

    end
 end
