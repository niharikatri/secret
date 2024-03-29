FactoryBot.define do
  sequence :email do |n|
    "user#{n}@exam#{n+1}ple.com"
  end
  email_account_name = 'AccountBlock::EmailAccount'
  factory :email_account, :class => 'AccountBlock::EmailAccount' do
    first_name { "test" }
    last_name { "demo"}
    email
    password { 'test@123' }
    type { 'EmailAccount' }
    full_phone_number { 9876543448}
     unique_auth_id { 123456 }
  end
end