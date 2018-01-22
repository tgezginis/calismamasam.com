class User < ApplicationRecord
  include IdentityCache

  acts_as_voter

  TEMP_EMAIL_PREFIX = 'change@me'.freeze
  TEMP_EMAIL_REGEX = /\Achange@me/
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable, :omniauthable

  cache_index :token, unique: true

  has_many :galleries
  has_many :likes
  has_many :identities

  validates :email, :name, :role, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  enum role: %i[user admin editor gallery_editor]

  scope :admins, -> { where('role is not null').where.not(role: :user) }

  before_validation :set_default_role
  before_create :generate_token

  attr_accessor :subscriber_agreement

  def set_default_role
    self.role ||= :user
  end

  def role?(base_role)
    role.to_s.to_sym == base_role.to_s.to_sym
  end

  roles.each do |user_role|
    define_method "#{user_role}?" do
      role && role?(user_role)
    end
  end

  def subscriber?
    !Subscriber.find_by(email: email)&.opted_out? || false
  end

  def add_as_subscriber
    subscriber = Subscriber.find_or_create_by(email: email)
    subscriber.opt_in
  end

  def opt_out_from_subscription
    return unless subscriber?
    subscriber = Subscriber.find_by(email: email)
    subscriber.opt_out
  end

  def like(likeable_type, likeable_id)
    likes.create(likeable_type: likeable_type.to_s, likeable_id: likeable_id)
  end

  def unlike(likeable_type, likeable_id)
    likes.where(likeable_type: likeable_type.to_s, likeable_id: likeable_id).delete_all
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0, 20]
        )
        user.save!
      end
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end
end
