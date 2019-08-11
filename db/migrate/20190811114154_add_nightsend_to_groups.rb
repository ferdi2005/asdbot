class AddNightsendToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :nightsend, :boolean, default: true
  end
end
