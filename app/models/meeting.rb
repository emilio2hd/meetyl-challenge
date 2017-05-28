class Meeting < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :place, :creator, presence: true
  validates :place, length: { maximum: 255 }
  validates_date :date
  validates_time :time
end
