class User < ApplicationRecord
  include IdentityCache

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable

  cache_index :token, unique: true

  has_many :galleries
  has_many :likes

  validates :email, :name, :role, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  enum role: %i[user admin editor gallery_editor]

  scope :admins, -> { where('role is not null').where.not(role: :user) }

  before_validation :set_default_role
  after_create :add_as_subscriber
  before_create :generate_token

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

  def add_as_subscriber
    subscriber = Subscriber.find_or_create_by(email: email)
    subscriber.opt_in
  end

  def like(likeable_type, likeable_id)
    likes.create(likeable_type: likeable_type.to_s, likeable_id: likeable_id)
  end

  def unlike(likeable_type, likeable_id)
    likes.where(likeable_type: likeable_type.to_s, likeable_id: likeable_id).delete_all
  end

  protected

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(token: random_token)
    end
  end
end
