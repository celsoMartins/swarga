# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { registrations: 'devise_custom/registrations' }

  resources :camping_groups, except: %i[edit update] do
    member do
      patch :pay_it
      patch :mark_exit
    end

    resources :vehicles, only: %i[index new create]
  end

  root 'camping_groups#index'
end
