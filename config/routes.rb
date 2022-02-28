Rails.application.routes.draw do
  devise_for :users
  root to: 'profile#home'
  get "/profile/new", to: "profile#new"
  post "/profile", to: "profile#create"
  get "/profile/:id", to: "profile#show"
  patch "/profile", to: "profile#update"
  get "/bank_info", to: "profile#bank_info"
  get "/confirmation", to: "profile#confirm"

  get "/cues", to: "cues#index"

  get "/user_cue/new", to: "user_cues#new"
  post "/user_cue", to: "user_cues#create"
  get "/user_cues/:id", to: "user_cues#show"
  get "/user_cues/:id/transaction", to: "transactions#index"
  get "/user_cues/:id/edit", to: "user_cues#edit"
  patch "/user_cues/:id", to: "user_cues#update"
  post "/user_cues/:id/transactions", to: "transactions#create"
end
