class AddVideoUrlToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :video_url, :string
  end
end
