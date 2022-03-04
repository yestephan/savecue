Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  get 'ui_kit', to: 'pages#ui_kit'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Profiles
  get "/home", to: "profiles#home"
  get "/profile/edit", to: "profiles#edit"
  patch "/profile", to: "profiles#update"
  get "/profile/:id", to: "profiles#show"

  # Confirmation route
  get "/confirmation", to: "profiles#confirm"  #Generic confirmation route

  # Cues and user_cues
  resources :cues, only: [:index] do
    resources :user_cues, only: [:new, :create]
  end

  resources :user_cues, only: [:index, :show, :edit, :update]
  get "/user_cue/update_city", to: 'user_cues#update_city'

  # Accounts
  resources :accounts, only: [:index, :update, :destroy]
  get "/accounts/debtor", to: "accounts#debtor"
  get "/signup/debtor-account", to: "accounts#debtor", defaults: {redirect_to: "signup/creditor-account"}
  post "/accounts/debtor", to: "accounts#create", defaults: {account_type: "debtor"}
  get "/accounts/creditor", to: "accounts#creditor"
  get "/signup/creditor-account", to: "accounts#debtor", defaults: {redirect_to: "/home"}
  post "/accounts/creditor", to: "accounts#create", defaults: { account_type: "creditor"}


end
