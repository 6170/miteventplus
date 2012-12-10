Risd::Application.routes.draw do
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show]
  resources :events do
    resources :uploads, :only => [:index, :show, :create, :destroy]
    resources :publicity_emails
    member do
      get 'publicity'
      get 'yelp'
      post 'yelp_search'
      post 'select_restaurant'
      post 'deselect_restaurant'
      delete 'clear_restaurants'
      get 'resources'
    end
  end
  resources :checklist_items do
    post 'edit_text', :on => :collection
    post 'toggle_checked', :on => :member
  end
  resources :tags
  resources :budget_items

  post "/events/:event_id/uploadFromRedactor" => "uploads#create_from_redactor"
  match "/events/:event_id/images" => "uploads#images", :as => "event_images"
  get "/settime/:id" => "events#new_time"
  post "/settime/:id" => "events#set_time"
end
