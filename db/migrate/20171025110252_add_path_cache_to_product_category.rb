class AddPathCacheToProductCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :product_categories, :path_cache, :string
  end
end
