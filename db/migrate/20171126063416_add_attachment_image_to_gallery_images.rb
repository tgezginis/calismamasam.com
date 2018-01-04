class AddAttachmentImageToGalleryImages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :gallery_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :gallery_images, :image
  end
end
