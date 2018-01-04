class CreateProductBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :product_brands do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
