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
        create_rule(:daily, params)
      end

      def create_weekly(params)
        rule = create_rule(:weekly, params)

        day_list = Array(params[:options][:day]).map! { |day| day =~ /\d/ ? day.to_i : day.to_sym }
        rule.day(day_list)

        rule
      end

      def create_monthly(params)
        rule = create_rule(:monthly, params)

        day_of_month_list = Array(params[:options][:day_of_month]).map!(&:to_i)
        rule.day_of_month(day_of_month_list)

        day_of_week = Hash.try_convert(params[:options][:day_of_week]) || {}
        day_of_week.each do |key, value|
          rule.day_of_week(key.to_sym => Array(value).map(&:to_i))
        end

        rule
      end

      def create_yearly(params)
        rule = create_rule(:yearly, params)

        day_of_year_list = Array(params[:options][:day_of_year]).map!(&:to_i)
        rule.day_of_year(day_of_year_list)

        month_of_year_list = Array(params[:options][:month_of_year]).map!(&:to_sym)
        rule.month_of_year(month_of_year_list)

        rule
      end

      private

      def create_rule(method, params)
        params[:options] ||= {}

        interval = params[:options][:interval].to_s.to_i
        interval = 1 if interval.zero?

        IceCube::Rule.public_send(method, interval)
      end
    end
  end
end