require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::CharactersController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @character = FactoryBot.create(:character)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        name: "Test",
        image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/test_image.gif'))
    }
    end
    it "create characters " do
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
    it "show characters details" do
      get :show, params: {id: @character.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        name: "characters"

    }
    end
    it "edit character" do
        put :edit, params: {id: @character.id, terms: params}
        expect(response).to have_http_status(200)
    end
  end
  describe '#update' do
    context 'with valid parameters' do
      before do
        put :update, params: { id: @character.id, character: { name: 'MyString' } }
      end

      it 'updates the character' do
        expect(@character.reload.name).to eq('MyString')
      end

      it 'redirects to the admin characters index page' do
        expect(response).to redirect_to(admin_characters_path)
      end

      it 'displays a update message' do
        expect(flash[:notice]).to eq('Character Successfully Updated ')
      end
    end
  end
  describe '#create' do
    context 'creates with valid parameters' do
      before do
        post :create, params: { character: { name: 'MyString' } }
      end

      it 'creates the character' do
        expect(@character.reload.name).to eq('MyString')
      end

      it 'redirects to index page' do
        expect(response).to redirect_to(admin_characters_path)
      end

      it 'displays a success message' do
        expect(flash[:notice]).to eq('Character Successfully Created ')
      end
    end
  end
  describe '#destroy' do
    context 'destroys character' do
      before do
        delete :destroy, params: { id: @character.id }
      end

      it 'redirects to  characters index page' do
        expect(response).to redirect_to(admin_characters_path)
      end

      it 'displays a destroy message' do
        expect(flash[:notice]).to eq('Character Successfully Destroyed')
      end
    end
  end
end