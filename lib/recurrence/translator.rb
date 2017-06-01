require 'recurrence/rule/daily'
require 'recurrence/rule/weekly'
require 'recurrence/rule/monthly'
require 'recurrence/rule/yearly'

module Recurrence
  module Translator
    class << self
      def parse(input)
        params = input.symbolize_keys
        case params[:recurrence].to_s.to_sym
        when :daily then Rule::Daily.new(params).create
        when :weekly then Rule::Weekly.new(params).create
        when :monthly then Rule::Monthly.new(params).create
        when :yearly then Rule::Yearly.new(params).create
        end
      end
    end
  end
end