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
      if self.time_block.starttime != DateTime.new(1,1,1,1,1)
        tb = self.time_block
        if Event.joins(:time_block).where(
          :title => self.title).where('time_blocks.starttime > ? AND
            time_blocks.starttime < ? AND 
            time_blocks.endtime > ? AND
            time_blocks.endtime < ?', tb.starttime - 1, tb.starttime + 1, tb.endtime - 1, tb.endtime + 1).size > 0
          errors[:base] << "This event is already in the database"
        end
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

  # performs a search on the Yelp API given a search term, zip and 
  # a page to offset results
  def yelp_search(search_term, search_zip, page)
    client = Yelp::Client.new
    search_request = Yelp::V2::Search::Request::Location.new(
      :term => search_term,
      :zip => search_zip,
      :state => "MA",
      :consumer_key => YELP_API['consumer_key'], 
      :consumer_secret => YELP_API['consumer_secret'], 
      :token => YELP_API['token'], 
      :token_secret => YELP_API['token_secret'],
      :offset => 10 * (page - 1),
      :limit => 10)

    client.search(search_request)
  end

  # performs a search on the Yelp API to suggest restaurants for an event 
  # given a sampled tag that is used to suggest.
  # if the sampled_tag is nil, then it does a default search for good restaurants
  # in the area.
  def yelp_suggestion(sampled_tag)
    if sampled_tag.nil?
      search_term = "restaurants delivery"
    else
      search_term = sampled_tag
    end

    client = Yelp::Client.new
    search_request = Yelp::V2::Search::Request::Location.new(
      :term => search_term,
      :city => "Cambridge", :state => "MA", :zip => "02139",
      :consumer_key => YELP_API['consumer_key'], 
      :consumer_secret => YELP_API['consumer_secret'], 
      :token => YELP_API['token'], 
      :token_secret => YELP_API['token_secret'],
      :limit => 10)

    client.search(search_request)
  end
end