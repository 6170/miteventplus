class EventRestaurant < ActiveRecord::Base
  belongs_to :event
  attr_accessible :event_id, :yelp_restaurant_id, :yelp_restaurant_name, :yelp_restaurant_url, :yelp_restaurant_phone


end
