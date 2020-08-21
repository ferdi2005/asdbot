class Group < ApplicationRecord
  has_many :asds
  has_many :special_events
  validates :chat_id, uniqueness: true
  validates :chat_id, :numericality => {:less_than_or_equal_to => 0 }
end
