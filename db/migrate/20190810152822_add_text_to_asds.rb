class AddTextToAsds < ActiveRecord::Migration[5.2]
  def change
    add_column :asds, :text, :string
  end
end
