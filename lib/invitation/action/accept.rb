require 'invitation/action/base_action'
require 'invitation/action/action_result'

module Invitation::Action
  class Accept < BaseAction
    def execute!(invitation)
      execute_action(invitation, &:accepted!)
    end
  end
end