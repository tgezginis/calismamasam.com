class GalleryImage < ApplicationRecord
  include IdentityCache

  belongs_to :gallery, counter_cache: true

  cache_belongs_to :gallery

  acts_as_list scope: :gallery_id
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

  validates_attachment :image, presence: true,
                               content_type: { content_type: /^image\/(jpg|jpeg|png)$/, message: 'sadece jpg ya da png formatında olmalıdır' },
                               size: { less_than: 1.megabytes, message: "boyutu maksimum 1 MB olmalıdır" }

  validates :title, :gallery, presence: true

  before_save :generate_file_name, if: :image_file_name_changed?

  after_validation :clean_paperclip_errors

  def clean_paperclip_errors
    errors.delete(:image_content_type)
    errors.delete(:image_file_size)
  end

  private

  def generate_file_name
    extension = File.extname(image_file_name).downcase
    random = Random.new.rand(10..1000)
    file_name = "#{gallery.title.parameterize}-#{random}"
    image.instance_write(:file_name, "#{file_name}#{extension}")
  end
end
