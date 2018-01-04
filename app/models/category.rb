class Category < ApplicationRecord
  include IdentityCache

  extend FriendlyId
  friendly_id :title, use: :slugged

  cache_index :slug, unique: true

  has_and_belongs_to_many :posts
  has_and_belongs_to_many :galleries

  validates_presence_of :title
end
