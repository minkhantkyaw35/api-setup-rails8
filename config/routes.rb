Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      devise_for :users, path: 'auth', controllers: {
        sessions: 'api/v1/auth/sessions',
        registrations: 'api/v1/auth/registrations'
      }

      # User routes
      resources :users, only: [:show, :update] do
        collection do
          get 'me/analytics', to: 'users#my_analytics'
          get 'me/devices', to: 'users#my_devices'
          delete 'me/devices/:device_id', to: 'users#remove_device'
        end
      end

      # Admin routes
      namespace :admin do
        resources :users do
          member do
            patch 'assign_roles'
            get 'analytics'
            patch 'device_limit', to: 'users#update_device_limit'
          end
        end
        resources :roles
        resources :permissions
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root 'rails/health#show'
end
