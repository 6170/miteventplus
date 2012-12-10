class EventsController < ApplicationController
  
  # returns json event objects for the events that fall between a given start and end time.
  # requires valid start and end dateTime object in params.
  def show
    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    events = []
    TimeBlock.where(:starttime => (start_time...end_time)).each do |t|
      e = t.event
      events << {:id => e.id, :description => e.description, :title => e.title, :allDay => false, :start => t.starttime, :end => t.endtime, :resource => e.id.to_s}
    end
    render :json => events

  end
  
  # returns json resource objects for the events that fall between a given start and end time.
  # requires valid start and end dateTime object in params.
  def resources
	  start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    resources = []
    resources << {:id => 'newevent', :name => 'Select a Time', :readonly => false}
    TimeBlock.where(:starttime => (start_time...end_time)).each do |t|
      e = t.event
      resources << {:id => e.id.to_s, :name => e.title, :readonly => true}
    end
    render :json => resources
  end

  # creates a new event object
  def new
    @event = Event.new
  end

  # creates a new event object from the params values of title and description.
  # it also prepopulates the checklist with 6 suggested checklist items, and creates
  # a "blank" default time block object for this event.
  # requires that all the values passed in from params are valid.
  def create
    @event = Event.new(:title => params[:event][:title], :description => params[:event][:description], :user_id => current_user.id)
    @event.id = Event.last.id + 1
    @event.create_time_block(:starttime => DateTime.new(1,1,1,1,1), :endtime => DateTime.new(1,1,1,1,1))
    if @event.save
      @event.checklist_items.create(:text => "Pick the date and time of your event.", :tag => "datetime")
      @event.checklist_items.create(:text => "Pick a restaurant to cater food for your event.", :tag => "food")
      @event.checklist_items.create(:text => "Send posters to CopyTech to print and publicize your event.", :tag => "copytech")
      @event.checklist_items.create(:text => "Upload files to your event", :tag => "filemanager")
      @event.checklist_items.create(:text => "Send publicity emails", :tag => "publicity")
      @event.checklist_items.create(:text => "Create a budget for your event", :tag => "budget")
      redirect_to :root
      return
    end
    render :new_event
  end

  # destroys an event object, and then redirects the user back
  # requires a valid id passed in with params.
  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  def publicity
    @event = current_user.events.find(params[:id])
    @publicity_emails = []
    current_user.events.each do |event|
      event.publicity_emails.each do |email|
        @publicity_emails << email
      end
    end
  end

  #Route: GET '/settime/:id'
  def new_time
    @event = current_user.events.find(params[:id])
  end

  #Route: POST '/settime/:id'
  def set_time
    this_event = Event.find(params[:id])
    parse = '%m/%d/%Y %I:%M:%S %p'
    start_date = DateTime.strptime(params[:start_date]+' '+params[:start_time], parse)
    end_date = DateTime.strptime(params[:end_date]+' '+params[:end_time], parse)
    this_time_block = this_event.time_block
    this_time_block.starttime = start_date
    this_time_block.endtime = end_date
    this_time_block.save

    this_event.checklist_items.find_by_tag("datetime").set_checked_true

    redirect_to :root
  end

  # sets up the variables for the yelp restaurant suggestion page.
  # passes to the view the event corresponding to the suggestion page,
  # the sampled_tag that was used for restaurant suggestion, and a hash 
  # that contains the response from the Yelp API call for suggested
  # restaurants.

  # requires that a valid id is passed in with params and that the Yelp
  # API is functional (and that our consumer keys/secrets/tokens are valid)
  def yelp
    @event = Event.find(params[:id])
    matched_tags = current_user.cross_reference_tags
    @sampled_tag = matched_tags.sample
    client = Yelp::Client.new
    if @sampled_tag.nil?
      suggested_request = Yelp::V2::Search::Request::Location.new(
        :term => "restaurants delivery",
        :city => "Cambridge", :state => "MA", :zip => "02139",
        :consumer_key => YELP_API['consumer_key'], 
        :consumer_secret => YELP_API['consumer_secret'], 
        :token => YELP_API['token'], 
        :token_secret => YELP_API['token_secret'],
        :limit => 10)
    else
      suggested_request = Yelp::V2::Search::Request::Location.new(
        :term => @sampled_tag, 
        :city => "Cambridge", :state => "MA", :zip => "02139", 
        :consumer_key => YELP_API['consumer_key'], 
        :consumer_secret => YELP_API['consumer_secret'], 
        :token => YELP_API['token'], 
        :token_secret => YELP_API['token_secret'],
        :limit => 10)
    end
    @suggested_restaurants = client.search(suggested_request)
  end

  # runs a search on Yelp API based on what the user typed in as a search_term
  # and search_zip. It always runs the search in MA because we assume that all clubs
  # using this will be at MIT (and hence in MA). Depending on the page of search results
  # we are asked to return, the yelp results will be offset by that amount.

  # requires that valid id, page, search_term, and search_zip be passed in with params.
  # also requires that the Yelp API is functional and that our authentication credentials are valid.
  def yelp_search
    @event = current_user.find(params[:id])
    @page = params[:page].to_i
    search_term = params[:search_term]
    search_zip = params[:search_zip]
    client = Yelp::Client.new
    search_request = Yelp::V2::Search::Request::Location.new(
      :term => @search_term,
      :zip => @search_zip,
      :state => "MA",
      :consumer_key => YELP_API['consumer_key'], 
      :consumer_secret => YELP_API['consumer_secret'], 
      :token => YELP_API['token'], 
      :token_secret => YELP_API['token_secret'],
      :offset => 10 * (@page - 1),
      :limit => 10)

    @search_results = client.search(search_request)

    respond_to do |format|
      format.js
    end
  end

  # adds a restaurant to be associated with an event (effectively choosing
  # a restaurant for an event) and then renders text.
  # requires that valid id, yelp_id, yelp_name, yelp_url, yelp_phone are passed
  # in with params.
  def select_restaurant
    event = current_user.events.find(params[:id])
    event.event_restaurants.create(:yelp_restaurant_id => params[:yelp_id],
      :yelp_restaurant_name => params[:yelp_name],
      :yelp_restaurant_url => params[:yelp_url],
      :yelp_restaurant_phone => (params[:yelp_phone].blank? ? nil : params[:yelp_phone]))

    event.checklist_items.find_by_tag("food").set_checked_true
    render :text => "Success!"
  end

  # removes a certain restaurant association with an event and then renders text.
  # requires that valid id and yelp_id are passed in with params.
  def deselect_restaurant
    event = current_user.events.find(params[:id])
    event.event_restaurants.find_by_yelp_restaurant_id(params[:yelp_id]).delete

    if event.event_restaurants.size == 0
      event.checklist_items.find_by_tag("food").set_checked_false
    end

    render :text => "Success!"
  end

  # removes all restaurant associations with a given event, resetting it back
  # to how it was before any restaurant selection
  # requires that valid id for an event is passed in with params.
  def clear_restaurants
    event = current_user.events.find(params[:id])
    event.event_restaurants.delete_all
    redirect_to :back
  end
end
