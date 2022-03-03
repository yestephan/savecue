Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'ui_kit', to: 'pages#ui_kit'


  devise_for :users

  # Profile
  get "/home", to: "profiles#home"
  get "/profile/new", to: "profiles#new"
  get "/profile/edit", to: "profiles#edit"
  post "/profile", to: "profiles#create"
  patch "/profile", to: "profiles#update"
  get "/profile/:id", to: "profiles#show"

  get "/bank_info", to: "profiles#bank_info"
  get "/confirmation", to: "profiles#confirm"

  get "/cues", to: "cues#index"
  get "/user_cue/update_city", to: 'user_cues#update_city'

  get "/user_cues", to: "user_cues#index"

  get "/user_cue/new", to: "user_cues#new"
  post "/user_cues", to: "user_cues#create"
  get "/user_cues/:id", to: "user_cues#show"
  get "/user_cues/:id/transaction", to: "transactions#index"
  get "/user_cues/:id/edit", to: "user_cues#edit"
  patch "/user_cues/:id", to: "user_cues#update"
  post "/user_cues/:id/transactions", to: "transactions#create"
end
