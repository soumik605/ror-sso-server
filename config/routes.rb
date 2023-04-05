Rails.application.routes.draw do
  namespace :admin_user do
    resources :users, only: [:index, :create, :update, :destroy]
    resources :oauth_clients, only: [:index, :create, :update, :destroy]
  end
  
  get 'dashboard/index'

  resources :oauth_clients
  devise_for :users, sign_out_via: [:get, :delete]

  # SSO Provider routes
  match '/auth/sso/authorize' => 'auth#authorize', via: :all
  match '/auth/sso/access_token' => 'auth#access_token', via: :all
  match '/auth/sso/user' => 'auth#user', via: :all
  match '/oauth/token' => 'auth#access_token', via: :all

  root "dashboard#index"
end
