class PublicityEmail < ActiveRecord::Base
  belongs_to :event
  attr_accessible :content, :subject
end
