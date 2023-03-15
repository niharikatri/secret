Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :account_block do
    resources :accounts
  end

  namespace :bx_block_login do
    resources :logins
  end

  namespace :bx_block_termsandconditions do
    resources :terms_and_conditions
  end

  namespace :bx_block_forgot_password do
    get 'generate_password_link', to: 'passwords#generate_password_link'
    put 'create_password', to: 'passwords#create_password'
  end
end
