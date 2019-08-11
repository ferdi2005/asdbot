class AddWelcomesentToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :welcomesent, :boolean, default: false
  end
end
