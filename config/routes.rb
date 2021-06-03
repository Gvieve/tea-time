Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resources :subscriptions, only: [:create]
      end
    end
  end
end
