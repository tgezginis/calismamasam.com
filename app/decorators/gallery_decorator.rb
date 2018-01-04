class GalleryDecorator < Draper::Decorator
  delegate_all

  def first_image_url(style = :full)
    return "/gallery-images/#{style}/missing.png" unless gallery_images.any?
    gallery_images.first.image.url(style)
  end

  def category_titles
    categories.pluck(:title).join(', ')
  end
end
