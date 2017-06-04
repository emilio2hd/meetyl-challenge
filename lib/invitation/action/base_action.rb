module Invitation::Action
  class BaseAction
    def execute_action(record)
      yield(record) if block_given?
      Invitation::Action::ActionResult.new(record)
    rescue ActiveRecord::RecordInvalid => ri
      Invitation::Action::ActionResult.new(ri.record, true)
    end
  end
end