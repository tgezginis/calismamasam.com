class Post < ApplicationRecord
  include Likeable
  include AlgoliaSearch
  extend FriendlyId

  friendly_id :title, use: :slugged

  cache_index :slug, unique: true

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :products
  has_many :post_images

  cache_has_many :post_images, embed: true

  has_attached_file :image,
                    styles: { full: '1500x750#', normal: '500x250#', thumb: '200x200#' },
                    convert_options: {
                      full: '-quality 80 -interlace Plane',
                      normal: '-quality 80 -interlace Plane',
                      thumb: '-quality 80 -interlace Plane'
                    },
                    default_url: '/images/:style/missing.png',
                    s3_headers: {
                      'Cache-Control' => 'max-age=315576000',
                      'Expires' => 10.years.from_now.httpdate
                    },
                    use_timestamp: false

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :body, :title, :job_title, :published_at, presence: true

  scope :active, -> { where(is_active: true).where('published_at < ?', Time.current).order(published_at: :desc, created_at: :desc) }
  scope :notifiable, -> { where(is_active: true).where('published_at between ? and ? and notified_at is null', 5.minutes.ago, Time.current + 5.minutes).order(published_at: :desc, created_at: :desc) }

  before_save :generate_file_name, if: :image_file_name_changed?

  algoliasearch per_environment: true do
    attribute :is_active, :title, :job_title, :company, :body, :slug
    add_attribute :published_at do
      published_at.present? ? published_at.to_i : (Time.current + 10.years).to_i
    end
    add_attribute :categories do
      categories.map(&:title)
    end
    add_attribute :products do
      products.map(&:name_with_brand)
    end
    tags do
      tags = []
      tags << 'published' if decorate.active?
      tags
    end

    customRanking ['desc(published_at)']
    attributesForFaceting %i[company categories products]
    minWordSizefor1Typo 8
    minWordSizefor2Typos 10
    hitsPerPage 20
  end

  private

  def generate_file_name
    extension = File.extname(image_file_name).downcase
    random = Random.new.rand(10..1000)
    file_name = if image.exists?
                  "#{title.parameterize}-#{job_title.parameterize}-#{random}"
                else
                  "#{title.parameterize}-#{job_title.parameterize}"
                end
    image.instance_write(:file_name, "#{file_name}#{extension}")
  end
end
