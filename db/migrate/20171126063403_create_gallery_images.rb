class CreateGalleryImages < ActiveRecord::Migration[5.1]
  def change
    create_table :gallery_images do |t|
      t.integer :gallery_id
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
