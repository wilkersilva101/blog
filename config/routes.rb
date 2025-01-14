Rails.application.routes.draw do
  # Rotas existentes
  devise_for :users, path: 'u'
  resources :articles
  resources :users
  resources :roles

  # Rota para o WeathersController (sem namespace)
  resources :weathers, only: [:index]

  # Ou, se estiver usando namespace:
  # namespace :blog do
  #   resources :weathers, only: [:index]
  # end

  get "up" => "rails/health#show", as: :rails_health_check

  root "articles#index"
end
