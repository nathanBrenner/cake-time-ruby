Rails.application.routes.draw do
  resources :alexa, only: [:create, :index]
  root "alexa#index"
end
