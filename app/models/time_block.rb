class TimeBlock < ActiveRecord::Base
  attr_accessible :starttime, :endtime
  belongs_to :event

  validates_presence_of :starttime, :endtime
end

