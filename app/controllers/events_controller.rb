class EventsController < ApplicationController
  def index
  end

  def show
    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    events = []
    TimeBlock.where(:starttime => (start_time...end_time)).each do |t|
      e = t.event
      events << {:id => e.id, :title => e.title, :allDay => false, :start => t.starttime, :end => t.endtime}
    end
    render :json => events

  end

  def new
    @event = Event.new
  end

  def create
    parse = '%m/%d/%Y %I:%M:%S %p'
    start_date = DateTime.strptime(params[:start_date]+' '+params[:start_time], parse)
    end_date = DateTime.strptime(params[:end_date]+' '+params[:end_time], parse)
    event = current_user.events.create(:title => params[:title], :location => params[:location], :description => params[:description]).create_time_block(:starttime => start_date, :endtime => end_date)

    event.checklist_items.create(:text => "Pick the date and time of your event.", :tag => "location")
    event.checklist_items.create(:text => "Pick a restaraunt to cater food for your event.", :tag => "food")
    event.checklist_items.create(:text => "Send posters to CopyTech to print and publicize your event.", :tag => "publicity")

    redirect_to '/'
  end

  def destroy
    Event.find(params[:id]).delete
    redirect_to :back
  end
end
