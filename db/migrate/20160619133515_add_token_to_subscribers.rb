class AddTokenToSubscribers < ActiveRecord::Migration[5.1]
  def change
    add_column :subscribers, :token, :string
    add_index :subscribers, :token, unique: true
  end
end
