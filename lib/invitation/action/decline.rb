module Invitation::Action
  class Decline
    def execute!(invitation)
      invitation.declined!
      invitation
    end
  end
end
