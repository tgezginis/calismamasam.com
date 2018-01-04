class Gallery < ApplicationRecord
  include Likeable
  extend FriendlyId

  friendly_id :title, use: :slugged

  cache_index :slug, unique: true

  belongs_to :user
  has_many :gallery_images, dependent: :destroy
  has_and_belongs_to_many :categories

  cache_has_many :gallery_images, embed: true

  validates :title, :user_id, :job_title, presence: true

  scope :active, -> { where(is_active: true).order(created_at: :desc) }

  accepts_nested_attributes_for :gallery_images, reject_if: :all_blank, allow_destroy: true

  after_create :notify_admins

  def notify_admins
    GalleryMailer.notify_admins(self).deliver_now rescue nil
  end
end
