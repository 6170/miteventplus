require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  ###event without start and end cannot be saved
  test " should not save event missing title" do
	event = Event.new
	assert !event.save
  end
  
  
end
