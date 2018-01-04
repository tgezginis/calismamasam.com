class RemoveVersionsTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :version_associations
    drop_table :versions
  end
end
