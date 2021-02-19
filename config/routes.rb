Rails.application.routes.draw do
  root "home#index"
  get "/dashboard", to: "home#index"
  resources :tasks, only: [:index, :create]
end
