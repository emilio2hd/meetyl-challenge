require 'invitation/action/accept'
require 'invitation/action/decline'

module Invitation::ActionLocator
  @actions = {}

  class << self
    def register(action_name, type_klass = nil)
      @actions[action_name] = type_klass
    end

    def lookup(action_name)
      @actions[action_name.to_sym].new
    end

    def has_action?(action_name)
      @actions.key? action_name.to_sym
    end
  end

  register(:accept, Invitation::Action::Accept)
  register(:decline, Invitation::Action::Decline)
end
