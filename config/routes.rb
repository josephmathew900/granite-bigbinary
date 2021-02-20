Rails.application.routes.draw do
  root "home#index"
  resources :tasks, except: %i[new edit]
  get '*path', to: 'home#index'
end
