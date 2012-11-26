class EventsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create

    redirect_to user_path(current_user);
  end

  def destroy
    Event.find(params[:id]).delete
    redirect_to :back
  end
end
