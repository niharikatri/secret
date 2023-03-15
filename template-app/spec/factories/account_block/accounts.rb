FactoryBot.define do
    factory :account, class: AccountBlock::Account do
      email { "test@gmail.com" }
      type {"EmailAccount"}
      password { "test@123" }
      activated {true}
      gender {"male"}
      reply_audio_setting { true }
      autoplay_setting { true }
    end
end