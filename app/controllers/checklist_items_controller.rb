class ChecklistItemsController < ApplicationController

  # creates a new checklist_item object for a given event, and
  # then responds with the created object in json format.
  # requires that a valid event_id and checklist text are passed in as params.
  def create
    @new_item = ChecklistItem.create(:text => params[:text], :event_id => params[:event_id])
    respond_to do |format|
      format.json{ render :json => @new_item}
    end
  end

  # deletes a checklist_item with a given id, and renders text if it's successful.
  # requires that a valid checklist_item id is passed as params.
  def destroy
    ChecklistItem.find(params[:id]).delete
    render :text => "Success!"
  end

  # toggles the "checked" boolean attribute in a checklist item, 
  # then renders text if it's successful
  # requires that a valid id for a checklist_item is passed in as params.
  def toggle_checked
    checklist_item = ChecklistItem.find(params[:id])
    checklist_item.update_attributes(:checked => !checklist_item.checked?)
    render :text => "Success!"
  end

  # edits the text of a checklist_item with whatever is passed in as value
  # in params.
  # requires that a valid id of a checklist_item is passed in as params,
  # and that a valid new value for the checklist_item is passed in as params.
  def edit_text
    checklist_item = ChecklistItem.find(params[:id])
    checklist_item.update_attributes(:text => params[:value])
    render :text => params[:value]
  end
end
