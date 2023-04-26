require 'rails_helper'
require 'spec_helper'
include Warden::Test::Helpers
RSpec.describe Admin::VoicesController, type: :controller do
  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    @voice = FactoryBot.create(:voice)
    sign_in @admin
  end
  describe "Post#new" do
    let(:params) do {
        name: "Test",
        audio: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/audio/test_audio.wav'))
    }
    end
    it "create voices " do
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
    it "show voices details" do
      get :show, params: {id: @voice.id}
      expect(response).to have_http_status(200)
    end
  end
  describe "Put#edit" do
    let(:params) do {
        name: "voices"

    }
    end
    it "edit voice" do
        put :edit, params: {id: @voice.id, terms: params}
        expect(response).to have_http_status(200)
    end
  end

  describe '#update' do
  context 'update voice with valid parameters' do
    before do
      put :update, params: { id: @voice.id, voice: { name: 'MyString' } }
    end

    it 'updates the voice' do
      expect(@voice.reload.name).to eq('MyString')
    end

    it 'redirects to the admin voices index page' do
      expect(response).to redirect_to(admin_voices_path)
    end

    it 'displays a update voice message' do
      expect(flash[:notice]).to eq('Voice Successfully Updated')
    end
  end
end
describe '#create' do
  context 'creates voice with valid parameters' do
    before do
      post :create, params: { voice: { name: 'Test' } }
    end

    it 'creates the Voice' do
      expect(@voice.reload.name).to eq('Test')
    end

    it 'redirects to index page' do
      expect(response).to redirect_to(admin_voices_path)
    end

    it 'displays a success message' do
      expect(flash[:notice]).to eq('Voice Successfully Created')
    end
  end
end
  describe '#destroy' do
    context 'destroys voice' do
      before do
        delete :destroy, params: { id: @voice.id }
      end

      it 'redirects to  voices index page' do
        expect(response).to redirect_to(admin_voices_path)
      end

      it 'displays a destroy voice message' do
        expect(flash[:notice]).to eq('Voice Successfully destroyed')
      end
    end
  end
end