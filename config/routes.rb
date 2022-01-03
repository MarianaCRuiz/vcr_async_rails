require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :reports, only: %i[index create destroy]
  root 'home#index'
end
