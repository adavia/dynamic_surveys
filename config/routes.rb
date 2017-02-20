require "sidekiq/web"

Rails.application.routes.draw do
  #mount Sidekiq::Web => "/sidekiq"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "sessions#new"

    resources :sessions, only: [:new, :create, :destroy]

    resources :users, only: [:show, :new, :create, :edit, :update]

    resources :customers, only: [:index, :show] do
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
      resources :submissions, only: [:index, :show, :new, :create]
    end

    resources :submissions, only: [] do
      collection do
        get :update_choices
      end
    end

    resources :images, only: :destroy

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
