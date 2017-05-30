require 'invitation/action/action_result'

module Invitation::Action
  class Decline
    def execute!(invitation)
      invitation.declined!
      Invitation::Action::ActionResult.new(invitation)
    end
  end
end
