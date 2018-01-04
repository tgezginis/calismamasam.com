class AddNotifiedAtToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :notified_at, :datetime
  end
end
