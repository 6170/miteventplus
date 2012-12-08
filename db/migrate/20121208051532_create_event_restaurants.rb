class CreateEventRestaurants < ActiveRecord::Migration
  def change
    create_table :event_restaurants do |t|
      t.integer :event_id, :null => false
      t.string :yelp_restaurant_id, :null => false
      t.string :yelp_restaurant_name, :null => false
      t.string :yelp_restaurant_phone
      t.timestamps
    end
  end
end
