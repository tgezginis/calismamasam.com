class HasManyPostsProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts_products, id: false do |t|
      t.belongs_to :post, index: true
      t.belongs_to :product, index: true
    end
  end
end
