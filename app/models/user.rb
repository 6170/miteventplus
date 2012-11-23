class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  # Validation that email is in ASA student group exec DB
  validate :must_be_asa_group_email
  
  has_many :events

  def must_be_asa_group_email
    if not AsaDb.find(:all).collect(&:email).include?(email)
      errors.add(:email, "is not a valid ASA student group officer mailing list.")
    end
  end
end
