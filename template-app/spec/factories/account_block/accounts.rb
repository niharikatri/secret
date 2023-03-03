FactoryBot.define do
    factory :account, class: AccountBlock::Account do
      email { "test@gmail.com" }
      type {"EmailAccount"}
      password { "test@123" }
      activated {true}
    end
end