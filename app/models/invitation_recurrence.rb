class InvitationRecurrence < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  validates :creator, :rule, :user, presence: true

  serialize :rule, IceCube::Schedule
end
