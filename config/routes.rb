Rails.application.routes.draw do
  root "pages#home"
  get "pricing", to: "pages#pricing"

  # Auth
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Endpoints
  resources :endpoints, only: [:index, :create], param: :token
  get "e/:token", to: "endpoints#show", as: :endpoint
  patch "e/:token", to: "endpoints#update"
  delete "e/:token", to: "endpoints#destroy", as: :destroy_endpoint

  # Team members
  post "e/:endpoint_token/team", to: "team_members#create", as: :endpoint_team_members
  delete "e/:endpoint_token/team/:id", to: "team_members#destroy", as: :endpoint_team_member

  # Replay
  post "replay", to: "replays#create"

  # Webhook receiver — catch ALL methods
  match "webhook/:token", to: "webhooks#receive", via: :all, as: :webhook

  # Health check
  get "up", to: "rails/health#show", as: :rails_health_check
end
