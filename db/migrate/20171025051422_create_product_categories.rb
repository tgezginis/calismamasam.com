class CreateProductCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :product_categories do |t|
      t.string :title
      t.string :ancestry
      t.integer :products_count, default: 0

      t.timestamps null: false
    end
    add_index :product_categories, :ancestry
  end
end
