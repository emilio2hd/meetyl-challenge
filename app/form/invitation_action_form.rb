require 'invitation/action_locator'

class InvitationActionForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :action

  validates :action, presence: true
  validate :check_action_availability

  def attributes
    { 'action' => nil, 'errors' => nil }
  end

  private

  def check_action_availability
    return if action.to_s.empty?
    errors.add(:action, "action '#{action}' not available") unless Invitation::ActionLocator.action? action
  end
end