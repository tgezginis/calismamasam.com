class AddTitleToGalleryImages < ActiveRecord::Migration[5.1]
  def change
    add_column :gallery_images, :title, :string
  end
end
