class Sender < ApplicationRecord
  has_many :asds
  validates :chat_id, uniqueness: true
end
