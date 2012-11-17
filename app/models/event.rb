class Event < ActiveRecord::Base
  belongs_to :user
  has_one :time_block
  attr_accessible :title, :location

end
