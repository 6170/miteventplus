class ChecklistItem < ActiveRecord::Base
  attr_accessible :event_id, :text, :checked, :tag
  validates_uniqueness_of :tag, :scope => :event_id, :allow_nil => true

  belongs_to :event

  # sets the checked boolean of a checklist item to true
  def set_checked_true
    self.checked = true
    self.save
  end

  # set the checked boolean of a checklist item to false
  def set_checked_false
    self.checked = false
    self.save
  end
end
