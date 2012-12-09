class BudgetItemsController < ApplicationController

# effects: Grabs all budget items for an event and computes their sum
def index
  @event = Event.find(params[:id])
  @b_items = @event.budget_items.all
  @sum = BudgetItem.where(:event_id => params[:id]).sum('value')
end

# effects: Creates a new budget item and sends it back in json format
def create
  @event = Event.find(params[:id])
  budget_item = @event.budget_items.create(:title => params[:title], :value => params[:value])
  respond_to do |format|
    format.json{ render :json => budget_item}
  end
end

# effects: Deletes a budget item
def destroy
  budget_item = BudgetItem.find(params[:id])
  budget_item.destroy
  render :json => 'success'
end

end
