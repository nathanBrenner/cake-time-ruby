Rails.application.routes.draw do
  resources :users
  resources :alexa, only: [:create, :index]
  root "alexa#index"
end
