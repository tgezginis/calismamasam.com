class AddSlugToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :slug, :string
    add_index :products, :slug, unique: true
  end
end
