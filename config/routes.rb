Rails.application.routes.draw do
  root "pages#home"

  # Devise for authentication
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Static and content pages
  get "about/history", to: "pages#history"
  get "about/team", to: "pages#team"
  get "about/contact", to: "contact_messages#new", as: :contact

  # Tag-based filtering
  get "tags/:id", to: "products#tagged", as: :tag

  # Cart & Wishlist
  get "/wishlist", to: "wishlist_items#index", as: :wishlist
  get "order_success/:id", to: "orders#success", as: :order_success

  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  # Core resources
  resources :products
  resources :contact_messages, only: [:new, :create]
  resources :categories, only: [:index, :show]
  resources :orders, only: [:index, :new, :create, :show]
  resources :wishlist_items, only: [:create, :destroy]
  resources :users, only: [:index, :show, :edit, :update]

  # Admin Dashboard & Inventory
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    get "inventory", to: "dashboard#inventory", as: :inventory

    resources :users, only: [:index, :show, :edit, :update, :destroy]

    resources :products, only: [] do
      patch :update_stock, on: :member

    end
  end

  # Manager Dashboard
  namespace :manager do
    get "dashboard", to: "dashboard#index"
  end

  # Stripe Webhooks
  post "/stripe/webhook", to: "webhooks#stripe"

  # Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end
