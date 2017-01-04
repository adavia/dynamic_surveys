require "sidekiq/web"

Rails.application.routes.draw do
  #mount Sidekiq::Web => "/sidekiq"

  root "sessions#new"

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, only: [:show, :new, :create, :edit, :update]

  resources :customers, only: [:index, :show] do
    resources :surveys, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :archive
      end
    end
  end

  resources :surveys, only: [] do
    collection do
      get :search
    end
    resources :submissions, only: [:index, :show, :new, :create]
  end

  resources :questions, only: [] do
    resources :answers, only: :index
  end

  namespace :admin do
    resources :users, only: [] do
      resources :customers, only: [:new, :create, :edit, :update] do
        member do
          patch :archive
        end
      end
    end

    resources :users, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :archive
      end
    end
  end

  namespace :api do
    resources :sessions, only: :create

    resources :customers, only: [] do
      resources :surveys, only: [:index, :show]
    end

    resources :surveys, only: [] do
      resources :submissions, only: :create
    end
  end
end
