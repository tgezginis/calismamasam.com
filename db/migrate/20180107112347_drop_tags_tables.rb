class DropTagsTables < ActiveRecord::Migration[5.1]
  def change
    drop_table(:taggings, if_exists: true)
    drop_table(:tags, if_exists: true)
  end
end
