class AsaDb < ActiveRecord::Base
  attr_accessible :email, :name
  
  validates_uniqueness_of :email
end
