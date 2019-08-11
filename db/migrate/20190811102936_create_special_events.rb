class CreateSpecialEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :special_events do |t|
      t.references :group, foreign_key: true
      t.string :text
      t.references :asd, foreign_key: true

      t.timestamps
    end
  end
end
