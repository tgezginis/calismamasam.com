class AddPositionToPostImages < ActiveRecord::Migration[5.1]
  def change
    add_column :post_images, :position, :integer, default: 0
  end
end
