Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get 'ui_kit', to: 'pages#ui_kit'
  devise_for :users

  # Profiles
  get "/home", to: "profiles#home"
  get "/profile/new", to: "profiles#new"
  get "/profile/edit", to: "profiles#edit"
  post "/profile", to: "profiles#create"
  patch "/profile", to: "profiles#update"
  get "/profile/:id", to: "profiles#show"
  get "/confirmation", to: "profiles#confirm"  #Generic confirmation route
  get "/bank_info", to: "profiles#bank_info"  #We probably should remove this

  # Cues
  get "/cues", to: "cues#index"

  # User_cues
  get "/user_cue/new", to: "user_cues#new"
  post "/user_cue", to: "user_cues#create"
  get "/user_cues/:id", to: "user_cues#show"
  get "/user_cues/:id/transaction", to: "transactions#index"
  get "/user_cues/:id/edit", to: "user_cues#edit"
  patch "/user_cues/:id", to: "user_cues#update"
  post "/user_cues/:id/transactions", to: "transactions#create"
end
