class Tag < ActiveRecord::Base
  validates :name, :length => {:maximum => 30}
  attr_accessible :name

  belongs_to :users


end