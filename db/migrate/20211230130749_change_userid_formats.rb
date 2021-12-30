class ChangeUseridFormats < ActiveRecord::Migration[5.2]
  def change
    change_column :senders, :chat_id, :bigint
    change_column :asds, :update_id, :bigint
  end
end
