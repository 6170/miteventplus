class BudgetItem < ActiveRecord::Base
  attr_accessible :event_id, :title, :value
  belongs_to :event
end
