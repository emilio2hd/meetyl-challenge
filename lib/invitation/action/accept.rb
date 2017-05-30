require 'invitation/action/action_result'

module Invitation::Action
  class Accept
    def execute!(invitation)
      invitation.accepted!
      Invitation::Action::ActionResult.new(invitation)
    rescue ActiveRecord::RecordInvalid => ri
      Invitation::Action::ActionResult.new(ri.record.errors, true)
    end
  end
end
