class AddTwitterUrlToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :twitter_url, :string
  end
end
