require "sidekiq/web"

Rails.application.routes.draw do
  #mount Sidekiq::Web => "/sidekiq"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "sessions#new"

    resources :sessions, only: [:new, :create, :destroy]

    resources :users, only: [:show, :new, :create, :edit, :update]

    resources :customers, only: [:index, :show] do
      collection do
        get :search
      end
      collection do
        get :own
      end
      resources :surveys, only: [:index, :show, :new, :create, :edit, :update] do
        member do
          patch :archive
        end
        member do
          get :preview
        end
      end
    end

    resources :surveys, only: [] do
      collection do
        get :search
      end
      member do
        get :images
      end
      member do
        get :modal_images
      end
      member do
        post :upload
      end
      resources :questions, only: [:new, :create, :edit, :update, :destroy]
      resources :submissions, only: [:index, :show, :new, :create]
      resources :alerts, only: [:index, :new, :create, :edit, :update, :destroy] do
      end
    end

    resources :alerts, only: [] do
      collection do
        get :update_choices
      end
    end

    resources :submissions, only: [:show] do
      collection do
        get :update_choices
      end
    end

    resources :images, only: :destroy

    resources :questions, only: [] do
      collection do
        post :sort
      end
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
  end

  #match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), via: :get
  #match '', to: redirect("/#{I18n.default_locale}"), via: :get

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
