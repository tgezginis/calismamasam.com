module Likeable
  extend ActiveSupport::Concern

  included do
    include IdentityCache
    
    has_many :likes, as: :likeable
    cache_has_many :likes, inverse_name: :likeable
  end

  def likes_count
    likes.count
  end

  def liked?(user)
    likes.where(user_id: user.id).any?
  end
end
