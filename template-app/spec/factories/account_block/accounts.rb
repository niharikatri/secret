FactoryBot.define do
    factory :account, class: AccountBlock::Account do
      first_name {"demo"}
      last_name {"test"}
     sequence(:email) { |n| "abc#{n}@example.com" }
      type {"EmailAccount"}
      password { "test@123" }
      password_confirmation {"test@123"}
      unique_auth_id { 123456 }
    end
end