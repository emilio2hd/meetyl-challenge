require 'recurrence/rule/base'

module Recurrence
  module Rule
    class Monthly < Base
      def initialize(params = {})
        super(:monthly, params)
      end

      def create
        day_of_month_list = Array(@options[:day_of_month]).map!(&:to_i)
        @rule.day_of_month(day_of_month_list)

        day_of_week = Hash.try_convert(@options[:day_of_week]) || {}
        day_of_week.each do |key, value|
          @rule.day_of_week(key.to_sym => Array(value).map(&:to_i))
        end

        @rule
      end
    end
  end
end