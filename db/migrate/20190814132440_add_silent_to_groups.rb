# frozen_string_literal: true

class AddSilentToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :silent, :boolean, default: false
  end
end
