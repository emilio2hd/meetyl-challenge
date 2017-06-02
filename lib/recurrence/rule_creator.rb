require 'recurrence/creator/daily'
require 'recurrence/creator/weekly'
require 'recurrence/creator/monthly'
require 'recurrence/creator/yearly'

module Recurrence
  module RuleCreator
    @creators = {}

    class << self
      def add(recurrence_type, creator_klass = nil)
        @creators[recurrence_type] = creator_klass
      end

      def create(recurrence)
        params = recurrence.with_indifferent_access
        recurrence_type = params[:type].to_sym

        creator_klass = @creators[recurrence_type]
        creator_klass.new(params).create
      end

      def creator?(recurrence_type)
        @creators.key? recurrence_type.to_s.to_sym
      end
    end

    add(:daily, Recurrence::Creator::Daily)
    add(:weekly, Recurrence::Creator::Weekly)
    add(:monthly, Recurrence::Creator::Monthly)
    add(:yearly, Recurrence::Creator::Yearly)
  end
end