Risd::Application.routes.draw do
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:index, :update, :destroy, :show]
  resources :events do
    resources :uploads
    resources :publicity_emails
  end
  resources :uploads
  resources :checklist_items
  resources :tags
  resources :budget_items

  get "/events/:id/publicity" => "events#publicity", :as => "event_publicity"
  post "/events/:event_id/uploadFromRedactor" => "uploads#create_from_redactor"
  match "/events/:event_id/images" => "uploads#images", :as => "event_images"
  match "/checklist_item/:id/toggle_checked" => "checklist_items#toggle_checked", :method => :post
  get "/settime/:id" => "events#new_time"
  post "/settime/:id" => "events#set_time"
  get "/events/:id/resources" => "events#resources", :as => "resources"
  get "/events/:id/yelp" => "events#yelp"
  match "/events/:id/yelp_search" => "events#yelp_search", :method => :post
  match "/events/:id/select_restaurant" => "events#select_restaurant", :method => :post
  match "/events/:id/deselect_restaurant" => "events#deselect_restaurant", :method => :post
  match "/events/:id/clear_restaurants" => "events#clear_restaurants"
  match "/checklist_items/edit_text" => "checklist_items#edit_text", :method => :post
end
