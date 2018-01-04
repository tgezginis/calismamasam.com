class CreateGalleries < ActiveRecord::Migration[5.1]
  def change
    create_table :galleries do |t|
      t.integer :user_id
      t.string :title
      t.boolean :is_active, default: false
      t.string :slug

      t.timestamps null: false
    end
  end
end
