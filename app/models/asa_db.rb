class AsaDb < ActiveRecord::Base
  attr_accessible :email, :name, :unprocessed_tags
  
  validates_uniqueness_of :email
end
