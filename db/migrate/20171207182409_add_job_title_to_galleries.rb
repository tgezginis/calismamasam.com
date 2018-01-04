class AddJobTitleToGalleries < ActiveRecord::Migration[5.1]
  def change
    add_column :galleries, :job_title, :string
  end
end
