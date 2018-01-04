class ChangeColumnTypeForPublishedAt < ActiveRecord::Migration[5.1]
  def change
    change_column :posts, :published_at, :datetime, null: false
  end
end
