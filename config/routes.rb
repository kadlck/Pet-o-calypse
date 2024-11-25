Rails.application.routes.draw do
  devise_for :users, only: []

  # Define a root path based on user authentication status
  authenticated :user do
    root "pets#index", as: :authenticated_root
  end

  root "home#index" # Fallback for unauthenticated users

  # Pets resource with custom actions
  resources :pets do
    member do
      patch :feed
      patch :play
      patch :nap
      patch :scavenge
      patch :fight
      patch :hide
      get :post_apocalypse
      post :trigger_apocalypse
    end
    resources :apocalypses, only: [ :index, :show ] do
        get :event
      end
  end
end
