Risd::Application.routes.draw do
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:index, :update, :destroy, :show]
  resources :events
  resources :checklist_items

  match "/user/events" => "users#events", :as => "user_events"
  match "/checklist_item/:id/toggle_checked" => "checklist_items#toggle_checked", :method => :post
end
