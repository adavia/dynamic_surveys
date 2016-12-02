Rails.application.routes.draw do
  root "sessions#new"

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create] do
    resources :customers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :customers, only: [] do
    resources :surveys, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end
end
