class InvitationRecurrence < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  scope :all_from, ->(creator_id) { where(creator_id: creator_id) }

  validates :creator, :rule, :user, presence: true

  serialize :rule, IceCube::Schedule

  def match?(date)
    rule.occurs_on?(date)
  end
end
