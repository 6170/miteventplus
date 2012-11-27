class ChecklistItem < ActiveRecord::Base
  attr_accessible :event_id, :text, :checked, :tag
  belongs_to :event
end
