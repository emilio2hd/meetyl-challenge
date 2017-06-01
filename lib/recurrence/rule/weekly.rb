require 'recurrence/rule/base'

module Recurrence
  module Rule
    class Weekly < Base
      def initialize(params = {})
        super(:weekly, params)
      end

      def create
        day_list = Array(@options[:day]).map! { |day| day =~ /\d/ ? day.to_i : day.to_sym }
        @rule.day(day_list)

        @rule
      end
    end
  end
end