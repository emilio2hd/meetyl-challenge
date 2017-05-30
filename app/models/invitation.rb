class Invitation < ApplicationRecord
  enum status: [ :pending, :accepted, :declined ]

  belongs_to :meeting
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'

  validates :meeting, :invitee, presence: true

  before_save :generate_access_code

  private

  def generate_access_code
    self[:access_code] = Base64.urlsafe_encode64("#{meeting_id}$#{invitee_id}$#{SecureRandom.uuid}")
  end
end
