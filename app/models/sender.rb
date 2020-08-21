# frozen_string_literal: true

class Sender < ApplicationRecord
  has_many :asds
  validates :chat_id, uniqueness: true
  validates :chat_id, numericality: { greater_than_or_equal_to: 0 }
end
