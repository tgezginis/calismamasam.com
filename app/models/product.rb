class Product < ApplicationRecord
  include IdentityCache

  extend FriendlyId
  friendly_id :name_with_brand, use: :slugged

  cache_index :slug, unique: true

  belongs_to :category, class_name: 'ProductCategory', foreign_key: 'category_id', counter_cache: true
  belongs_to :brand, class_name: 'ProductBrand', foreign_key: 'brand_id'
  has_and_belongs_to_many :posts

  validates :name, :category_id, presence: true
  validates :name, uniqueness: true

  has_attached_file :image,
                    styles: { full: '1500x1500>', thumb: '200x200#' },
                    convert_options: {
                      full: '-quality 80 -interlace Plane',
                      thumb: '-quality 80 -interlace Plane'
                    },
                    default_url: '/product-images/:style/missing.png',
                    s3_headers: { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
                    use_timestamp: false
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_save :generate_file_name, if: :image_file_name_changed?

  def name_with_brand
    decorate.name_with_brand
  end

  private

  def generate_file_name
    extension = File.extname(image_file_name).downcase
    random = Random.new.rand(10..1000)
    file_name = "#{name.parameterize}-#{random}"
    image.instance_write(:file_name, "#{file_name}#{extension}")
  end
end
