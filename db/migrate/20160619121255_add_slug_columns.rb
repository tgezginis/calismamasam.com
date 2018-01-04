class AddSlugColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true
    add_column :categories, :slug, :string
    add_index :categories, :slug, unique: true
  end
end
