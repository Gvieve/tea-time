Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resources :subscriptions, only: [:index, :create, :update]
        resources :tea_subscriptions, only: [:index]
      end
    end
  end
end
