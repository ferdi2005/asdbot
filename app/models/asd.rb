class Asd < ApplicationRecord
  belongs_to :group
  belongs_to :sender
  validates :update_id, uniqueness: true 
end
