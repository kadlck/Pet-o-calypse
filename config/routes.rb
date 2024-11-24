Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root "pets#index", as: :authenticated_root
  end

  root "home#index" # Fallback for unauthenticated users

# config/routes.rb
resources :pets do
  member do
    patch :feed
    patch :play
    patch :nap
    patch :scavenge
    patch :fight
    patch :hide
  end
  get :post_apocalypse, on: :member
  post :trigger_apocalypse, on: :member
end
end
