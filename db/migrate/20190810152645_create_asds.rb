class CreateAsds < ActiveRecord::Migration[5.2]
  def change
    create_table :asds do |t|
      t.references :group, foreign_key: true
      t.references :sender, foreign_key: true
      t.integer :update_id
      
      t.timestamps
    end
  end
end
