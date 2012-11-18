class EventsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    current_user.events.create(params[:event])
    redirect_to user_path(current_user);
  end

  def destroy
  end
end
