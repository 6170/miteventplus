class Event < ActiveRecord::Base
  belongs_to :user
  has_one :time_block, :dependent => :delete
  has_many :checklist_items, :dependent => :delete_all
  has_many :uploads, :dependent => :delete_all
  has_many :publicity_emails, :dependent => :delete_all
  attr_accessible :title, :location, :description, :user_id
  validates :title, :presence => true
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