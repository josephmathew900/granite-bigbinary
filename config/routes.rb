Rails.application.routes.draw do 
  resources :tasks, except: %i[new edit]
  resources :users, only: %i[create index]
  resource :sessions, only: [:create, :destroy]
  resources :comments, only: :create
  root "home#index"
  get '*path', to: 'home#index'
end
