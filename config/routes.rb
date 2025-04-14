Rails.application.routes.draw do
  get "orders/new"
  get "orders/create"
  get "orders/show"
  get "cart_items/create"
  get "cart_items/update"
  get "cart_items/destroy"
  get "carts/show"
  root "pages#home"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  get "about/history", to: "pages#history"
  get "about/team", to: "pages#team"
  get "about/contact", to: "contact_messages#new", as: :contact
  get "tags/:id", to: "products#tagged", as: :tag
  get "/wishlist", to: "wishlist_items#index", as: :wishlist
  get "order_success/:id", to: "orders#success", as: :order_success


  resources :products
  resources :contact_messages, only: [ :new, :create ]
  resources :categories, only: [ :index, :show ]
  resources :orders, only: [ :index, :new, :create, :show ]
  resources :wishlist_items, only: [ :create, :destroy ]  # for wishlist items
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]
  resources :users, only: [ :index, :show, :edit, :update ]


  namespace :admin do
    get "dashboard", to: "dashboard#index"
  end

  namespace :manager do
    get "dashboard", to: "dashboard#index"
  end

  post "/stripe/webhook", to: "webhooks#stripe"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
