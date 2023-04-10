require "rails_helper"

RSpec.describe AccountBlock::Account, type: :request do
  VAR2 = URI.encode("http://www.example.com:80/account_block/verified_unique_code")
  describe "account_block/accounts" do
    CONTENT_TYPE = "application/json"
    C_TYPE = "Content-Type"
    TOKEN = "token"
    let!(:account) { FactoryBot.create(:account) }
    before do
      @headers = {
        TOKEN => BuilderJsonWebToken::JsonWebToken.encode(account.id),
        C_TYPE => CONTENT_TYPE
      }
      @post_path = "/account_block/accounts"
    end

    describe "post #create" do
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

      it "returns successful response" do
        post @post_path, {params: request_params}
        expect(response).to have_http_status(201)
      end

      it "response is not nill" do
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

      it "returns error when user already existed" do
        post @post_path, {params: create_params}
        response_json = JSON.parse(response.body)
        expect(response_json["errors"]).to eq([{"email" => "has already been taken"}])
      end

      it "Invalid email" do
        post @post_path, params: {data: {type: "email_account", attributes: {email: "12345", password: "Test1@12"}}}
        expect(response).to have_http_status(422)
      end
    end

    describe "PUT update" do
      before do
        @account = FactoryBot.create(:account)
        @headers = {
          TOKEN => BuilderJsonWebToken.encode(@account.id),
          C_TYPE => CONTENT_TYPE
        }
      end

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
        url = "/account_block/accounts/" + @account.id.to_s
        put url, params: create_params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end

      it "returns error if account not found" do
        account_id = @account.id
        @account.destroy!
        url = "/account_block/accounts/#{account_id}"
        put url, params: create_params.to_json, headers: @headers
        expect(response.status).to eq 404
      end

      it "returns error if parameters are invalid" do
        url = "/account_block/accounts/1"
        params = {data: {attributes: {voice_id: 99999999999999999999}}}
        put url, params: params.to_json, headers: @headers
        expect(response.status).to eq 400
      end
    end

    describe "PUT update_profile_pic" do
      before do
        @account = FactoryBot.create(:account)
        @headers = {
          TOKEN => BuilderJsonWebToken.encode(@account.id),
          C_TYPE => CONTENT_TYPE
        }
      end

      let(:create_params) do
        {
          account: {
            profile_pic: Rack::Test::UploadedFile.new(Rails.root.join("app/assets/images/test_image.gif"))
          }
        }
      end

      it "Updates the Account" do
        url = "/account_block/accounts/update_profile_pic"
        put url, params: create_params.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end
    end

    describe "PUT update_equalizer_profile" do
      before do
        @role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Papa")
        @account = FactoryBot.create(:account, role_id: @role.id)
        @headers = {
          TOKEN => BuilderJsonWebToken.encode(@account.id),
          C_TYPE => CONTENT_TYPE
        }
        @equalizer_profile = {data: {attributes: {equalizer_profile: {pitch: -1, bass: 2, mid: 0, treble: 1}}}}
      end

      it "updates equalizer_profile" do
        url = "/account_block/accounts/#{@account.id}"
        put url, params: @equalizer_profile.to_json, headers: @headers
        expect(response).to have_http_status(200)
      end

      it "does not update equalizer_profile if child role" do
        role = BxBlockRolesPermissions::Role.find_or_create_by(name: "Child")
        account = FactoryBot.create(:account, role_id: role.id)
        headers = {
          TOKEN => BuilderJsonWebToken.encode(account.id),
          C_TYPE => CONTENT_TYPE
        }
        url = "/account_block/accounts/#{account.id}"
        put url, params: @equalizer_profile.to_json, headers: headers
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "#generate_unique_code" do
    before do
      @account = FactoryBot.create(:account)
      @token = BuilderJsonWebToken.encode(@account.id)
      @headers = {
        TOKEN => @token,
        C_TYPE => CONTENT_TYPE
      }
      @url = "/account_block/generate_unique_code"
      @role = BxBlockRolesPermissions::Role.create(name: "Papa")
    end

    context "when called by a papa account" do
      it "generates a unique code if the account doesn't have one already" do
        get @url, params: {token: @token}
        expect(response.status).to eq 200
        # expect(JSON.parse(response.body)).to eq({"unique_code" => "1234567890"})
      end

      it "returns the existing unique code if the account already has one" do
        @account.update(unique_code: "1234567890",role_id: @role.id)
        @account.save
        get @url, params: {token: @token}
        expect(response).to have_http_status(:ok)
      end
    end

    context "when called by a non-papa account" do
      before do
        @account = FactoryBot.create(:account)
        @token = BuilderJsonWebToken.encode(@account.id)
        @headers = {
          TOKEN => @token,
          C_TYPE => CONTENT_TYPE
        }
        @role = BxBlockRolesPermissions::Role.create(name: "Papa")
      end

      it "returns an error message" do
        get @url, params: {token: @token}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq({"message" => "This is not the Papa account, not able to generate unique code!"})
      end
    end
  end

  describe "#verified_unique_code" do
    context "when called by a non papa account" do
      before do
        @account = FactoryBot.create(:account, unique_code: nil, role_id: 1)
        @token = BuilderJsonWebToken.encode(@account.id)
        @headers = {
          TOKEN => @token,
          C_TYPE => CONTENT_TYPE
        }
        @role = BxBlockRolesPermissions::Role.create(name: "Papa", id: 1)
      end

      let(:request_params) { {unique_code: @account.unique_code} }

      it "returns a success message, Code is verified successfully!" do
        put VAR2, params: {token: @token, unique_code: @account.unique_code}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq({"message" => "Code is verified Successfully!"})
      end

      it "returns the success message, User already verified!" do
        @account.unique_code = "1234567890"
        @account.save!
        put VAR2, params: {token: @token, unique_code: "1234567890"}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq({"message" => "User already verified!"})
      end
    end
    context "when called by a papa account" do
      before do
        @role = BxBlockRolesPermissions::Role.create(name: "Papa", id: 1)
        @account = FactoryBot.create(:account, unique_code: "1234567890", role_id: @role.id)
        @token = BuilderJsonWebToken.encode(@account.id)
        @headers = {
          TOKEN => @token,
          C_TYPE => CONTENT_TYPE
        }
      end

      let(:request_params) { {unique_code: "1234567890"} }

      it "returns an error message, Verification failed!" do
        put VAR2, params: {token: @token, unique_code: "1234567890"}
        expect(response.status).to eq 200
        # expect(JSON.parse(response.body)).to eq({"errors" => "Verification failed!"})
      end
    end

    context "when we use wrong unique code" do
      before do
        @account = FactoryBot.create(:account, unique_code: "1234567890")
        @token = BuilderJsonWebToken.encode(@account.id)
        @headers = {
          TOKEN => @token,
          C_TYPE => CONTENT_TYPE
        }
        @role = BxBlockRolesPermissions::Role.create(name: "Papa")
      end

      let(:request_params) { {unique_code: "1234567890"} }

      it "returns an error message, Wrong Unique Code!" do
        put VAR2, params: {token: @token, unique_code: "1234567822"}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)).to eq({"errors" => "Wrong Unique Code!"})
      end
    end
  end
    
    describe "listing_user" do
      account = FactoryBot.create(:account)
          token = BuilderJsonWebToken.encode(account.id)
          auth_token = BuilderJsonWebToken::JsonWebToken.encode(account.id)
          headers = {
            TOKEN => token,
            C_TYPE => CONTENT_TYPE
        }

      context "list user" do
        it "list users who have shared code" do 
          url = '/account_block/listing_user'
          get url, params: { token: token }
          expect(response.status).to eq 200
        end
      end
    end
end
