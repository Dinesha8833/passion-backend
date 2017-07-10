Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :todos, only: [:index, :create, :update, :destroy] do
        resources :items, only: [:index, :create, :update, :destroy] do
          member do
            patch :complete
            patch :set_order
          end
        end
      end
    end
  end
end
