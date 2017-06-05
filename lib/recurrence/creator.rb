module Recurrence
  class Creator
    SAFE_METHODS = %w(day day_of_week day_of_month day_of_year month_of_year).freeze

    def initialize(rule_name, params = {})
      @options = params[:options] ||= {}

      interval = @options[:interval].to_s.to_i
      interval = 1 if interval.zero?
      @options.delete(:interval)

      @rule = IceCube::Rule.public_send(rule_name, interval)
    end

    def create
      combine
      @rule
    end

    def combine
      @options.each_key { |key| send("apply_#{key}") if SAFE_METHODS.include?(key.to_s) }
    end

    def apply_day
      days = Array(@options[:day]).map(&:to_sym)
      @rule.day(days)
    end

    def apply_day_of_week
      day_of_week = Hash.try_convert(@options[:day_of_week]) || {}
      day_of_week.each do |key, value|
        @rule.day_of_week(key.to_sym => Array(value).map(&:to_i))
      end
    end

    def apply_day_of_month
      day_of_month = Array(@options[:day_of_month]).map(&:to_i)
      @rule.day_of_month(day_of_month)
    end

    def apply_day_of_year
      day_of_year = Array(@options[:day_of_year]).map(&:to_i)
      @rule.day_of_year(day_of_year)
    end

    def apply_month_of_year
      month_of_year = Array(@options[:month_of_year]).map(&:to_sym)
      @rule.month_of_year(month_of_year)
    end
  end
end