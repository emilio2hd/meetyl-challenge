module Recurrence
  module Rule
    class Base
      def initialize(rule_name, params = {})
        @options = params[:options] ||= {}

        interval = @options[:interval].to_s.to_i
        interval = 1 if interval.zero?

        @rule = IceCube::Rule.public_send(rule_name, interval)
      end

      def create
        raise NotImplementedError, 'The #create should be implemented by subclasses'
      end
    end
  end
end