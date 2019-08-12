class Group < ApplicationRecord
  has_many :asds
  has_many :special_events
  validates :chat_id, uniqueness: true
end
