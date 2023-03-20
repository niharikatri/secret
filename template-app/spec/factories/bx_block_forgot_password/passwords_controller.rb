FactoryBot.define do
    factory :password, class: BxBlockForgotPassword::PasswordsController do
      new_password { "test@123" }
    end
end