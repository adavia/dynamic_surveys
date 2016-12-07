Rails.application.routes.draw do
  root "sessions#new"

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create] do
    resources :customers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :customers, only: [] do
    resources :surveys, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :surveys, only: [] do
    resources :submissions, only: [:new, :create]
  end

  namespace :api do
    resources :sessions, only: :create

    resources :customers, only: :index do
      resources :surveys, only: [:index, :show]
    end
  end
end
