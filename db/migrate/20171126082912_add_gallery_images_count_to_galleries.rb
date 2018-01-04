class AddGalleryImagesCountToGalleries < ActiveRecord::Migration[5.1]
  def change
    add_column :galleries, :gallery_images_count, :integer, default: 0
  end
end
