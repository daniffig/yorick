Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Funeral notices with dasherized routes
  resources :funeral_notices, only: [:index], path: 'funeral-notices'
  
  # Custom show route with date/name_hash format
  get 'funeral-notices/:date/:name_hash', to: 'funeral_notices#show', as: :funeral_notice

  # Defines the root path route ("/")
  root "funeral_notices#index"
end
