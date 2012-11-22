class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  # Validation that email is in ASA student group exec DB
  validates_inclusion_of :email, :in => AsaDb.find(:all).collect(&:email), :message => "is not a valid ASA student group officer mailing list."
  
  has_many :events
end
