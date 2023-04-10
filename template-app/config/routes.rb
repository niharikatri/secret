Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/account_block/generate_unique_code', to: 'account_block/accounts#generate_unique_code'
  put '/account_block/verified_unique_code', to: 'account_block/accounts#verified_unique_code'
  namespace :account_block do
    resources :accounts do
      put :update_profile_pic, on: :collection
    end
    resources :characters, only: [:index]
    resources :voices, only: [:index]
    resources :languages, only: [:index]
    get 'listing_user', to: 'accounts#listing_user' 
  end

  namespace :bx_block_login do
    resources :logins
  end

  namespace :bx_block_termsandconditions do
    resources :terms_and_conditions
  end

  namespace :bx_block_forgot_password do
    put 'generate_password_link', to: 'passwords#generate_password_link'
    put 'create_password', to: 'passwords#create_password'
  end
  namespace :bx_block_admin do
  	resources :about_us, only: [:index]
  	resources :privacy_policies, only: [:index]
  	resources :how_we_works
  end

  namespace :bx_block_login do
    resources :logouts, only: [:destroy]
  end

  namespace :bx_block_roles_permissions do
    resources :roles, only: [:index]
  end

end
