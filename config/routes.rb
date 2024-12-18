Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  get "dashboard", to: "home#dashboard"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :connections, only: [ :index, :show ]
  resources :apps, only: [ :index ] do
      resources :connections, only: [ :new, :create ]
  end
  resources :employees, only: [ :index, :show ]
  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "oauth_callback/:app_name", to: "oauth#oauth_callback", as: :oauth_callback

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
end
