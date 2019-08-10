class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.bigint :chat_id
      t.string :username

      t.timestamps
    end
  end
end
