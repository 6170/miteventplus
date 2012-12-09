class Event < ActiveRecord::Base
  belongs_to :user
  has_one :time_block, :dependent => :delete
  has_many :checklist_items, :dependent => :delete_all
  has_many :uploads, :dependent => :delete_all
  has_many :publicity_emails, :dependent => :delete_all
  has_many :budget_items, :dependent => :delete_all
  has_many :event_restaurants, :dependent => :delete_all
  attr_accessible :title, :description, :user_id
  validates :title, :presence => true
  validate :ensure_event_is_unique

  # before an event is inserted, we have to make sure that it is a unique event
  def ensure_event_is_unique
    # check if event is already in database
  	if self.time_block
      tb = self.time_block
      if Event.joins(:time_block).where(
        :title => self.title, 
        :location => self.location).where('time_blocks.starttime > ? AND
          time_blocks.starttime < ? AND 
          time_blocks.endtime > ? AND
          time_blocks.endtime < ?', tb.starttime - 1, tb.starttime + 1, tb.endtime - 1, tb.endtime + 1).size > 0
        errors[:base] << "This event is already in the database"
      end
    # no timeblock associated
  	else
  		errors[:base] << "This event does not have a time"
  	end
  end

  # checks to see if this event is associated with a restaurant with 
  # a certain yelp_id
  def has_restaurant(yelp_id)
    self.event_restaurants.each do |restaurant|
      if restaurant.yelp_restaurant_id == yelp_id
        return true
      end
    end

    return false
  end
end