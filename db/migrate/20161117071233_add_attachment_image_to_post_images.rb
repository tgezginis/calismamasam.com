class AddAttachmentImageToPostImages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :post_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :post_images, :image
  end
end
