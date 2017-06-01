require 'recurrence/rule/base'

module Recurrence
  module Rule
    class Yearly < Base
      def initialize(params = {})
        super(:yearly, params)
      end

      def create
        day_of_year_list = Array(@options[:day_of_year]).map!(&:to_i)
        @rule.day_of_year(day_of_year_list)

        month_of_year_list = Array(@options[:month_of_year]).map!(&:to_sym)
        @rule.month_of_year(month_of_year_list)

        @rule
      end
    end
  end
end