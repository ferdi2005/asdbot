class AddClassificaToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :classifica, :boolean, default: true
  end
end
