require 'recurrence/creator/daily'
require 'recurrence/creator/weekly'
require 'recurrence/creator/monthly'
require 'recurrence/creator/yearly'

module Recurrence
  module Translator
    @creators = {}

    class << self
      def add(recurrence_type, recurrence_creator_klass = nil)
        @creators[recurrence_type] = recurrence_creator_klass
      end

      def parse(input)
        params = input.symbolize_keys
        recurrence_type = params[:recurrence].to_s.to_sym

        recurrence_creator_klass = @creators[recurrence_type]
        recurrence_creator_klass.new(params).create
      end

      def creators?(recurrence_type)
        @creators.key? recurrence_type.to_sym
      end
    end

    add(:daily, Recurrence::Creator::Daily)
    add(:weekly, Recurrence::Creator::Weekly)
    add(:monthly, Recurrence::Creator::Monthly)
    add(:yearly, Recurrence::Creator::Yearly)
  end
end