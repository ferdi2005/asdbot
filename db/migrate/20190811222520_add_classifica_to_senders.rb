class AddClassificaToSenders < ActiveRecord::Migration[5.2]
  def change
    add_column :senders, :classifica, :boolean, default: true
  end
end
