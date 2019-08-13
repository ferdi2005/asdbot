class Asd < ApplicationRecord
  belongs_to :group
  belongs_to :sender
  validates :update_id, uniqueness: true, presence: false
  has_many :special_events
  before_create :default_values
  def default_values
    self.multiple_times = multiple_times.presence || 0
  end
  def self.totalcount
    self.count + pluck(:multiple_times).sum
  end
end
