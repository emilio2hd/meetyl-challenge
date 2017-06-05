require 'invitation/action/base_action'
require 'invitation/action/action_result'

module Invitation::Action
  class Decline < BaseAction
    def execute!(invitation)
      execute_action(invitation, &:declined!)
    end
  end
end
