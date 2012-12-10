class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :club_name, :email, :password, :password_confirmation, :remember_me, :confirmed_at
  
  # Validation that email is in ASA student group exec DB
  validate :must_be_asa_group_email

  after_create :prepopulate_tags
  
  has_many :events
  has_many :tags

  # before created a user, validate that it is a asa group by checking the
  # email against our database of asa group exec emails.
  def must_be_asa_group_email
    if not AsaDb.find(:all).collect(&:email).include?(email)
      errors.add(:email, "is not a valid ASA student group officer mailing list.")
    else
      self.club_name = AsaDb.find_by_email(self.email).name
    end
  end

  # when a user is created, extract the tags that are paired with the user's group
  # and associate those with the newly created user.
  def prepopulate_tags
    preprocessed_tags = AsaDb.find_by_name(self.club_name).unprocessed_tags
    if preprocessed_tags != nil
      preprocessed_tags.split(",").each do |tag|
        self.tags.create(:name => tag)
      end
    end
  end

  # find which tags of this user match "fuzzily" with yelp restaurant categories.
  def cross_reference_tags_and_sample
    jarow = FuzzyStringMatch::JaroWinkler.create(:native)
    matched_tags = []
    self.tags.each do |tag|
      YELP_API_CATEGORIES.map{|category| jarow.getDistance(tag.name, category)}.each_with_index do |score, index|
        if score >= 0.9
          matched_tags << YELP_API_CATEGORIES[index]
        end
      end
    end
    matched_tags.sample
  end
end
