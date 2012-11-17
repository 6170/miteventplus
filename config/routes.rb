Risd::Application.routes.draw do
  get "users/index"

  get "users/update"

  get "users/destroy"

  root :to => "home#index"
  devise_for :users
  resources :users
  resources :events
end
