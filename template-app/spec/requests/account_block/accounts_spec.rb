require 'rails_helper'

RSpec.describe AccountBlock::Account, type: :request do
  VAR2 = URI.encode("http://www.example.com:80/account_block/verified_unique_code")
    describe 'account_block/accounts' do
      CONTENT_TYPE = "application/json"
      C_TYPE = "Content-Type"
      TOKEN = "token"
      let!(:account) { FactoryBot.create(:account) }   
      before do
        auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
        @headers = {
          TOKEN => auth_token,
          C_TYPE => CONTENT_TYPE
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
              email: account.email,
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
          TOKEN => token,
          C_TYPE => CONTENT_TYPE
        }
        url = '/account_block/accounts/' + account.id.to_s
        put url, params: create_params.to_json, headers: headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

    end

    describe "PUT update_profile_pic" do
      let(:create_params) do
          {
           account: {
            "profile_pic": Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/test_image.gif'))
          }
        }
      end
      it "Updates the Account" do 
        account = FactoryBot.create(:account)
        token = BuilderJsonWebToken.encode(account.id)
        auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
        headers = {
          TOKEN => token,
          C_TYPE => CONTENT_TYPE
        }
        url = '/account_block/accounts/update_profile_pic'
        put url, params: create_params.to_json, headers: headers
        data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
      end

    end
  end

    describe "#generate_unique_code" do
      account = FactoryBot.create(:account)
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }

      context "when called by a parent1 account" do
        it "generates a unique code if the account doesn't have one already" do
            url = '/account_block/generate_unique_code'
            get url, params: { token: token }
          expect(response.status).to eq 200
        end
        it "returns the existing unique code if the account already has one" do
          account.update(unique_code: "1234567890")
          account.save
          url = '/account_block/generate_unique_code'
          get url, params: { token: token }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to eq({ "unique_code" => "1234567890" })
        end
      end

      context "when called by a non-parent1 account" do
        account = FactoryBot.create(:account)
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }
        it "returns an error message" do
          url = '/account_block/generate_unique_code'
          get url, params: { token: token,  }
          expect(response.status).to eq 200
        end
      end
    end

    describe "#verified_unique_code" do
      context "when called by a non parent1 account" do
        account = FactoryBot.create(:account, unique_code: nil, role_id: nil)
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }
        let(:request_params) do
          {
            unique_code: "1234567890"
          }
        end
        it "returns a success message, Code is verified successfully!" do
          put VAR2, params: { token: token, unique_code: "1234567890" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to eq({ "message" => "Code is verified Successfully!" })
        end
        it "returns the success message, User already verified!" do
          put VAR2, params: { token: token, unique_code: "1234567890" }
          expect(response.status).to eq 200
        end
      end

      context "when called by a parent1 account" do
        account = FactoryBot.create(:account, unique_code: "1234567890")
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }

        let(:request_params) do
          {
            unique_code: "1234567890"
          }
        end
        it "returns an error message" do
          put VAR2, params: { token: token, unique_code: "1234567890" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to eq({ "errors" => "This is a Parent1 user,Verification failed!" })
        end
      end
      context "when we use wrong unique code" do
        account = FactoryBot.create(:account, unique_code: "1234567890")
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }

        let(:request_params) do
          {
            unique_code: "1234567890"
          }
        end
        it "returns an error message" do
          put VAR2, params: { token: token, unique_code: "1234567822" }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to eq({ "errors" => "Wrong Unique Code!" })
        end
      end
    end
  end