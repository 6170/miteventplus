class EventsController < ApplicationController

  def index
  end

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

    this_event.checklist_items.where(:tag => "datetime")[0].set_checked_true

    redirect_to :root
  end

  def yelp

  end
end
