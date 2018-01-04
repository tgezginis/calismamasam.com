require 'securerandom'

class Subscriber < ApplicationRecord
  mailkick_user

  validates :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  before_create :generate_token

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Subscriber.exists?(token: random_token)
    end
  end
end
