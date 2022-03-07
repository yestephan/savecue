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
  post "/home", to: "profiles#new_transaction", as: "new_transaction"

  # Confirmation route
  get "/confirmation", to: "profiles#confirm" #Generic confirmation route

  # Cues and user_cues
  resources :cues, only: [:index] do
    resources :user_cues, only: [:new, :create, :destroy]
  end

  resources :user_cues, only: [:show, :edit, :update]

  # Accounts
  resources :accounts, only: [:index, :update, :destroy]
  get "/accounts/checking", to: "accounts#checking"
  get "/signup/checking-account", to: "accounts#checking", defaults: { redirect_to: "signup/savings-account"}
  post "/accounts/checking", to: "accounts#create", defaults: { account_type: "checking" }
  get "/accounts/savings", to: "accounts#savings"
  get "/signup/savings-account", to: "accounts#savings", defaults: {redirect_to: "/home" }
  post "/accounts/savings", to: "accounts#create", defaults: { account_type: "savings" }

end
