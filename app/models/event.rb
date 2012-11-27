class Event < ActiveRecord::Base
  belongs_to :user
  has_one :time_block
  attr_accessible :title, :location, :description
  validate :ensure_event_is_unique

  def ensure_event_is_unique
    # check if event is already in database
  	if self.time_block
      tb = self.time_block
      if Event.joins(:time_block).where(
        :title => self.title, 
        :location => self.location).where('time_blocks.starttime > ? AND
          time_blocks.starttime < ? AND 
          time_blocks.endtime > ? AND
          time_blocks.endtime < ?', tb.starttime - 1, tb.starttime + 1, tb.endtime - 1, tb.endtime + 1).size > 0
        errors[:base] << "This event is already in the database"
      end
    # no timeblock associated
  	else
  		errors[:base] << "This event does not have a time"
  	end
  end
end

=begin

Savon event pulling	

# Gets events from clubs/interest groups from start_date to end_date. 
client = Savon.client("http://events.mit.edu/MITEventsFull.wsdl")
response = client.request :mns, :get_category_events do
  soap.namespaces["xmlns:mns"] = "http://events.mit.edu/MIT/Events/EventManager"
  soap.body = {
  	:category_id => 7,
  	:start_date => "2012/11/26",
  	:end_date => "2012/11/26"
  }
end
items = response.body[:get_category_events_response][:array][:item]
items.each do |item|
  item[:description]
  item[:start]
  item[:end]
  item[:location]
  item[:infomail]
end

=end