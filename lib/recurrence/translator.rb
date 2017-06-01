module Recurrence
  module Translator
    class << self
      def parse(input)
        params = input.symbolize_keys
        case params[:recurrence].to_s.to_sym
        when :daily then create_daily(params)
        when :weekly then create_weekly(params)
        when :monthly then create_monthly(params)
        when :yearly then create_yearly(params)
        end
      end

      def create_daily(params)
        interval = 1
        if params.key?(:options) && params[:options].is_a?(Hash)
          opt_interval = params[:options][:interval].to_s.to_i
          interval = opt_interval unless opt_interval.zero?
        end

        IceCube::Rule.daily(interval)
      end

      def create_weekly(params)
        interval = 1

        if params.key?(:options) && params[:options].is_a?(Hash)
          opt_interval = params[:options][:interval].to_s.to_i
          interval = opt_interval unless opt_interval.zero?
        end

        rule = IceCube::Rule.weekly(interval)

        if params.key?(:options) && params[:options].key?(:day) && params[:options][:day].is_a?(Array)
          days = params[:options][:day].map { |day| day =~ /\d/ ? day.to_i : day }
          days.map! { |day| day.is_a?(String) ? day.to_sym : day}
          rule.day(days)
        end

        rule
      end

      def create_monthly(params)
        interval = 1

        if params.key?(:options) && params[:options].is_a?(Hash)
          opt_interval = params[:options][:interval].to_s.to_i
          interval = opt_interval unless opt_interval.zero?
        end

        rule = IceCube::Rule.monthly(interval)

        if params.key?(:options) && params[:options].key?(:day_of_month) && params[:options][:day_of_month].is_a?(Array)
          days = params[:options][:day_of_month].collect(&:to_i)
          rule.day_of_month(*days)
        end

        if params.key?(:options) && params[:options].key?(:day_of_week) && params[:options][:day_of_week].is_a?(Hash)
          params[:options][:day_of_week].each do |key, value|
            rule.day_of_week(key.to_sym => value.map(&:to_i))
          end
        end

        rule
      end

      def create_yearly(params)
        interval = 1

        if params.key?(:options) && params[:options].is_a?(Hash)
          opt_interval = params[:options][:interval].to_s.to_i
          interval = opt_interval unless opt_interval.zero?
        end

        rule = IceCube::Rule.yearly(interval)

        if params.key?(:options) && params[:options].key?(:day_of_year) && params[:options][:day_of_year].is_a?(Array)
          days = params[:options][:day_of_year].collect(&:to_i)
          rule.day_of_year(*days)
        end

        if params.key?(:options) && params[:options].key?(:month_of_year) && params[:options][:month_of_year].is_a?(Array)
          months = params[:options][:month_of_year].collect(&:to_sym)
          rule.month_of_year(*months)
        end

        rule
      end
    end
  end
end