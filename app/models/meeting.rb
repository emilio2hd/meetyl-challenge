class Meeting < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :participants, through: :invitations, source: :user
  has_many :invitations

  scope :as_creator, ->(user_id) { where(creator_id: user_id) }

  def self.of_user(user_id)
    as_invitee = left_joins(:invitations).where('invitations.invitee_id = ?', user_id)
    left_joins(:invitations).as_creator(user_id).or(as_invitee)
  end

  validates :place, :creator, presence: true
  validates :place, length: { maximum: 255 }
  validates_date :date
  validates_time :time
end
