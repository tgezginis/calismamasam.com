class DropProductImagesTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :product_images
  end
end
