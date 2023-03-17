Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :account_block do
    resources :accounts
    resources :characters, only: [:index]
    resources :voices, only: [:index]
  end

  namespace :bx_block_termsandconditions do
    resources :terms_and_conditions
  end
end
