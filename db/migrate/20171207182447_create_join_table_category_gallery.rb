class CreateJoinTableCategoryGallery < ActiveRecord::Migration[5.1]
  def change
    create_join_table :categories, :galleries do |t|
      t.index [:category_id, :gallery_id]
      t.index [:gallery_id, :category_id]
    end
  end
end
