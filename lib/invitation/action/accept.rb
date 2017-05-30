module Invitation::Action
  class Accept
    def execute!(invitation)
      invitation.accepted!
      invitation
    end
  end
end
