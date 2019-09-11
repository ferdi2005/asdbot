class AddEliminazioneToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :eliminazione, :boolean, default: false
  end
end
