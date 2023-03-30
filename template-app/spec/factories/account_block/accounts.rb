FactoryBot.define do
    factory :account, class: AccountBlock::Account do
      first_name {"demo"}
      last_name {"test"}
      sequence(:email) { |n| "abc#{n}@example.com" }
      type {"EmailAccount"}
      password { "test@123" }
      password_confirmation {"test@123"}
      unique_auth_id { 123456 }
      activated {true}
      gender {"male"}
      reply_audio_setting { true }
      autoplay_setting { true }
      profile_pic {Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/test_image.gif'))}
      role_id {"1"}
      unique_code {"1678993677"}
    end
end