class PostImage < ApplicationRecord
  include IdentityCache

  belongs_to :post

  cache_belongs_to :post

  acts_as_list scope: :post_id
  scope :ordered, -> { order(position: :asc) }
  default_scope { ordered }

  has_attached_file :image,
                    styles: { full: '1500x1500>', thumb: '200x200#' },
                    convert_options: {
                      full: '-quality 80 -interlace Plane',
                      thumb: '-quality 80 -interlace Plane'
                    },
                    default_url: '/images/:style/missing.png',
                    s3_headers: { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
                    use_timestamp: false
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_save :generate_file_name, if: :image_file_name_changed?

  private

  def generate_file_name
    extension = File.extname(image_file_name).downcase
    random = Random.new.rand(10..1000)
    file_name = "#{post.title.parameterize}-#{post.job_title.parameterize}-#{random}"
    image.instance_write(:file_name, "#{file_name}#{extension}")
  end
end
