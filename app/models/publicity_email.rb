class PublicityEmail < ActiveRecord::Base
  belongs_to :event
  attr_accessible :content, :subject, :event_id
  validates :content, :uniqueness => {:scope => :event_id} 

  def describe
  	self.event.title.to_s + " (" + self.event.time_block.starttime.to_date.to_s + ") - " + self.subject 
  end
end
