class AddAncestryDepthColumnToProductCategoryTable < ActiveRecord::Migration[5.1]
  def change
    add_column :product_categories, :ancestry_depth, :integer, default: 0
  end
end
