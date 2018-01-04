class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.boolean :is_active, default: false
      t.string :title
      t.string :job_title
      t.string :company
      t.text :body
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
