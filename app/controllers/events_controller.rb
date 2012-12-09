class EventsController < ApplicationController
  def show
    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    events = []
    TimeBlock.where(:starttime => (start_time...end_time)).each do |t|
      e = t.event
      events << {:id => e.id, :title => e.title, :allDay => false, :start => t.starttime, :end => t.endtime, :resource => e.id.to_s}
    end
    render :json => events

  end
  
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

  def new
    @event = Event.new
  end

  def create
    parse = '%m/%d/%Y %I:%M:%S %p'
    start_date = DateTime.strptime(params[:start_date]+' '+params[:start_time], parse)
    end_date = DateTime.strptime(params[:end_date]+' '+params[:end_time], parse)
    event = Event.create(:title => params[:title], :location => params[:location], :description => params[:description]).create_time_block(:starttime => start_date, :endtime => end_date)

    redirect_to :root
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to :back
  end

  def new_event
    @event = Event.new
  end

  def create_event
    @event = Event.new(:title => params[:event][:title], :description => params[:event][:description], :user_id => current_user.id)
    @event.id = Event.last.id + 1
    @event.create_time_block(:starttime => DateTime.now, :endtime => DateTime.now)
    if @event.save
      @event.checklist_items.create(:text => "Pick the date and time of your event.", :tag => "datetime")
      @event.checklist_items.create(:text => "Pick a restaurant to cater food for your event.", :tag => "food")
      @event.checklist_items.create(:text => "Send posters to CopyTech to print and publicize your event.", :tag => "copytech")
      @event.checklist_items.create(:text => "Upload files to your event", :tag => "filemanager")
      @event.checklist_items.create(:text => "Send publicity emails", :tag => "publicity")
      redirect_to :root
      return
    end
    render :new_event
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

  def yelp_search
    @event = Event.find(params[:id])
    @page = params[:page].to_i
    @search_term = params[:search_term]
    @search_zip = params[:search_zip]
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

  def select_restaurant
    event = Event.find(params[:id])
    event.event_restaurants.create(:yelp_restaurant_id => params[:yelp_id],
      :yelp_restaurant_name => params[:yelp_name],
      :yelp_restaurant_url => params[:yelp_url],
      :yelp_restaurant_phone => (params[:yelp_phone].blank? ? nil : params[:yelp_phone]))

    render :text => "Success!"
  end

  def deselect_restaurant
    event = Event.find(params[:id])
    event.event_restaurants.find_by_yelp_restaurant_id(params[:yelp_id]).delete

    render :text => "Success!"
  end

  def clear_restaurants
    event = Event.find(params[:id])
    event.event_restaurants.delete_all
    redirect_to :back
  end
end
