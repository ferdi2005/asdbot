class ChangeChatIdToBeBigintInGroups < ActiveRecord::Migration[5.2]
  def change
    change_column :groups, :chat_id, :bigint
  end
end
