require 'recurrence/rule_creator'

class Invitation < ApplicationRecord
  enum status: [ :pending, :accepted, :declined ]

  belongs_to :meeting
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'

  scope :recurrent_accepted, ->(meeting_id) { where(meeting_id: meeting_id, recurrent: true, status: :accepted) }

  attr_accessor :recurrence, :rule, :start_time, :end_time

  validates :meeting, :invitee, presence: true
  validate :check_if_there_is_recurrent
  validates_with RecurrenceValidator

  before_create :generate_access_code
  after_save :create_invitation_recurrence

  def accepted!
    return if self[:status] == :accepted

    transaction do
      self[:status] = :accepted
      meeting.increment_participants!
      save!
    end
  end

  def declined!
    return if self[:status] == :declined

    transaction do
      self[:status] = :declined
      meeting.decrement_participants!
      save!
    end
  end

  private

  def check_if_there_is_recurrent
    errors.add(:meeting, 'You have already accepted the invitation for this meeting') if invitation_recurrent?
  end

  def invitation_recurrent?
    accepted? && self[:recurrent] == true &&
      self.class.recurrent_accepted(self[:meeting_id]).count.positive?
  end

  def generate_access_code
    self[:access_code] = Base64.urlsafe_encode64("#{meeting_id}$#{invitee_id}$#{SecureRandom.uuid}")
  end

  def create_invitation_recurrence
    return if @rule.nil?

    @rule.until(end_time) if end_time

    recurrence_rule = IceCube::Schedule.new(start_time) { |schedule| schedule.add_recurrence_rule(@rule) }

    InvitationRecurrence.create(creator: meeting.creator, user: invitee, rule: recurrence_rule)
  end
end
