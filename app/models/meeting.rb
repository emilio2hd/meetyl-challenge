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
  validate :check_maximum_participants
  validates_date :date
  validates_time :time

  after_commit :fire_recurrence_invitation

  def increment_participants!
    increment(:participants_count).save! if maximum_participants?
  end

  def declined_participants!
    decrement(:participants_count).save! if maximum_participants?
  end

  private

  def fire_recurrence_invitation
    InvitationRecurrence.all_from(creator.id).find_each(&method(:invite_if_match))
  end

  def invite_if_match(recurrence)
    Invitation.create!(meeting_id: id, invitee_id: recurrence.user_id, recurrent: true) if recurrence.match?(date)
  rescue ActiveRecordError => error
    logger.error(error)
  end

  def maximum_participants?
    self[:maximum_participants].positive?
  end

  def check_maximum_participants
    return if self[:maximum_participants].zero?

    if self[:participants_count] > self[:maximum_participants]
      errors.add(:maximum_participants, 'Meeting overbooked, maximum participants has been reached')
    end
  end
end
