require 'recurrence/rule/base'

module Recurrence
  module Rule
    class Daily < Base
      def initialize(params = {})
        super(:daily, params)
      end

      def create
        @rule
      end
    end
  end
end