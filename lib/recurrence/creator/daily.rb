require 'recurrence/creator/base'

module Recurrence
  module Creator
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