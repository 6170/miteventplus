class BudgetItemsController < ApplicationController

def index
  @event = Event.find(params[:id])
  @b_items = @event.budget_items.all
  @sum = BudgetItem.where(:event_id => params[:id]).sum('value')
  @b_map = {}
  @b_items.each do |b|
    @b_map[b.title]=(100 * b.value/@sum).round(2)
  end
end

def create
  @event = Event.find(params[:id])
  budget_item = @event.budget_items.create(:title => params[:title], :value => params[:value])
  respond_to do |format|
    format.json{ render :json => budget_item}
  end
end

def destroy
  budget_item = BudgetItem.find(params[:id])
  budget_item.destroy
  render :json => 'success'
end

end
