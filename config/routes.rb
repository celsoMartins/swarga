# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { registrations: 'devise_custom/registrations' }

  resources :camping_groups do
    member do
      patch :pay_it
      patch :mark_exit
    end

    resources :vehicles, only: %i[new create]
    resources :people, only: %i[new create edit update]
  end

  root 'camping_groups#index'
end
