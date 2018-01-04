class HasManyCategoriesPosts < ActiveRecord::Migration[5.1]
  def change
   create_table :categories_posts, id: false do |t|
     t.belongs_to :post, index: true
     t.belongs_to :category, index: true
   end
 end
end
