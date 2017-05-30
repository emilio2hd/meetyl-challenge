require 'invitation/action_locator'

class InvitationActionForm
  include ActiveModel::Model

  attr_accessor :action

  validates :action, presence: true
  validate :check_action_availability

  private

  def check_action_availability
    return if action.to_s.empty?
    errors.add(:action, "action '#{action}' not available") unless Invitation::ActionLocator.action? action
  end
end