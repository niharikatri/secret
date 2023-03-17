FactoryBot.define do
  factory :character, class: 'AccountBlock::Character' do
    name { "MyString" }
    image {Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/test_image.gif'))}
  end
end
