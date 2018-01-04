class CreateProductImages < ActiveRecord::Migration[5.1]
  def change
    create_table :product_images do |t|
      t.integer :product_id
      t.boolean :is_active
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
