class ChecklistItemsController < ApplicationController

  def index
  end

  def show
  end

  def new
    @checklist_item = ChecklistItem.new
  end

  def create
    start_date = DateTime.parse(params[:start_date]+params[:start_time])
    end_date = DateTime.parse(params[:end_date]+params[:end_time])
    current_user.events.create(:title => params[:title], :location => params[:location], :description => params[:description]).time_block.create(:starttime => start_date, :endtime => end_date)
    redirect_to user_path(current_user)
  end

  def destroy
    ChecklistItem.find(params[:id]).delete
    redirect_to :back
  end
end
