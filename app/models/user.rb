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

  before_create :prepopulate_tags
  
  has_many :events
  has_and_belongs_to_many :tags

  def must_be_asa_group_email
    if not AsaDb.find(:all).collect(&:email).include?(email)
      errors.add(:email, "is not a valid ASA student group officer mailing list.")
    else
      self.club_name = AsaDb.find_by_email(self.email).name
    end
  end

  def prepopulate_tags
    preprocessed_tags = AsaDb.find_by_name(self.name).unprocessed_tags
    preprocessed_tags.split(",").each do |tag|
      self.tags.create(:name => tag)
    end
  end

  def cross_reference_tags
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    matched_tags = []
    self.tags.each do |tag|
      YELP_API_CATEGORIES.map{|category| jarow.getDistance(tag.name, category)}.each_with_index do |score, index|
        if score >= 0.9
          matched_tags << YELP_API_CATEGORIES[index]
        end
      end
    end
    matched_tags
  end
end
