class CreateSenders < ActiveRecord::Migration[5.2]
  def change
    create_table :senders do |t|
      t.integer :chat_id
      t.string :username

      t.timestamps
    end
  end
end
