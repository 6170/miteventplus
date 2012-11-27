Risd::Application.routes.draw do
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:index, :update, :destroy, :show]
  resources :events
  resources :checklist_items


  match "/create_event" => "events#create_event", :method => :post
  match "/new_event" => "events#new_event"
  match "/user/events" => "users#events", :as => "user_events"
  match "/checklist_item/:id/toggle_checked" => "checklist_items#toggle_checked", :method => :post
  get "/settime/:id" => "events#new_time"
  post "/settime/:id" => "events#set_time"
end
