class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :senders, :name, :string
  end
end
