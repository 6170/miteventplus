class ChecklistItemsController < ApplicationController

  def index
  end

  def show
  end

  def new
    @checklist_item = ChecklistItem.new
  end

  def create
    @new_item = ChecklistItem.create(:text => params[:text], :event_id => params[:event_id])
    respond_to do |format|
      format.json{ render :json => @new_item}
    end
  end

  def destroy
    ChecklistItem.find(params[:id]).delete
    render :text => "Success!"
  end

  def toggle_checked
    checklist_item = ChecklistItem.find(params[:id])
    checklist_item.update_attributes(:checked => !checklist_item.checked?)
    render :text => "Success!"
  end

  def edit_text
    checklist_item = ChecklistItem.find(params[:id])
    checklist_item.update_attributes(:text => params[:value])
    render :text => params[:value]
  end
end
