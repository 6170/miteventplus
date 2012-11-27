class TimeBlock < ActiveRecord::Base
  attr_accessible :starttime, :endtime
  belongs_to :event

end

