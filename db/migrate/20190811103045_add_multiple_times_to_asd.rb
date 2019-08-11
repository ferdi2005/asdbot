class AddMultipleTimesToAsd < ActiveRecord::Migration[5.2]
  def change
    add_column :asds, :multiple_times, :integer
  end
end
