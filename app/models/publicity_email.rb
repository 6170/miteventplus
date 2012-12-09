class PublicityEmail < ActiveRecord::Base
  belongs_to :event
  attr_accessible :content, :subject, :event_id
  validates :content, :uniqueness => {:scope => :event_id} 

  # renders string that describes this publicity email method
  # (essentially a to_string method)
  def describe
  	starttime = self.event.time_block.starttime
  	dateString = ""
  	
  	if starttime == DateTime.new
  	  dateString = "No Date" 
  	else dateString = starttime.to_date.to_s
  	end

  	self.event.title.to_s + " (" + dateString + ") - " + self.subject 
  end
end
