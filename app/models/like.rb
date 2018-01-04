class Like < ApplicationRecord
  include IdentityCache
  
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  cache_belongs_to :likeable

  validates_uniqueness_of :likeable_id, scope: %i[likeable_type user_id]
end
