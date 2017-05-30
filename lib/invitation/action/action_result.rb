module Invitation::Action
  class ActionResult
    attr_reader :result

    def initialize(result, error = false)
      @result = result
      @error = error
    end

    def error?
      @error
    end
  end
end