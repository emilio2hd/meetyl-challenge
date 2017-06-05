require 'recurrence/creator'

module Recurrence
  module RuleCreator
    TYPES = %w(daily weekly monthly yearly).freeze

    class << self
      def create(recurrence)
        params = recurrence.with_indifferent_access
        recurrence_type = params[:type].to_sym
        Recurrence::Creator.new(recurrence_type, params).create
      end

      def creator?(recurrence_type)
        TYPES.include?(recurrence_type.to_s)
      end
    end
  end
end