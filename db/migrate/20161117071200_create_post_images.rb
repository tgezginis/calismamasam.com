class CreatePostImages < ActiveRecord::Migration[5.1]
  def change
    create_table :post_images do |t|
      t.references :post, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
