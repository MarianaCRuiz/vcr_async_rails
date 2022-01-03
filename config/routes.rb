require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :reports, only: %i[index create destroy] do
    delete 'destroy_all', on: :collection
  end
  root 'home#index'
end
