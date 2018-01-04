class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :category_id
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
