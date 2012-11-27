class Event < ActiveRecord::Base
  belongs_to :user
  has_one :time_block
  has_many :checklist_items
  attr_accessible :title, :location, :description, :user_id

end
