class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :club_name, :email, :password, :password_confirmation, :remember_me
  
  # Validation that email is in ASA student group exec DB
  validate :must_be_asa_group_email
  
  has_many :events

  def must_be_asa_group_email
    if not AsaDb.find(:all).collect(&:email).include?(email)
      errors.add(:email, "is not a valid ASA student group officer mailing list.")
    else
      self.club_name = AsaDb.find_by_email(self.email).name
    end
  end
end
