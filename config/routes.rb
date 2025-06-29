Rails.application.routes.draw do
  use_doorkeeper_openid_connect
  use_doorkeeper
  devise_for :users

  # mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  namespace :admin do
    root "dashboard#index" # default landing page
    resources :users
    resources :applications
  end

  namespace :oauth do
    get "/userinfo", to: "userinfo#show"
    get "/jwks", to: "jwks#show"
  end

  # get "/.well-known/openid-configuration", to: "well_known#openid_configuration"
  get "/token/validate", to: "token_validations#show"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
