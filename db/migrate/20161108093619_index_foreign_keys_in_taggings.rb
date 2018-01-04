class IndexForeignKeysInTaggings < ActiveRecord::Migration[5.1]
  def change
    add_index :taggings, :tagger_id
  end
end
