class CreateSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribers do |t|
      t.string :email

      t.timestamps null: false
    end
    add_index :subscribers, :email, unique: true
  end
end
