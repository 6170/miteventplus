class ChecklistItem < ActiveRecord::Base
  attr_accessible :event_id, :text, :checked, :tag
  belongs_to :event

  def set_checked_true
    self.checked = true
    self.save
  end

  def set_checked_false
    self.checked = false
    self.save
  end
end
