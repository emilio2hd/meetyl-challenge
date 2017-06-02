require 'rails_helper'
require 'recurrence/creator/daily'

RSpec.describe Recurrence::Creator::Daily do
  describe '#create' do
    it 'creates a daily rule' do
      rule = described_class.new({}).create
      expect(rule).to be_kind_of(IceCube::DailyRule)
    end

    it 'should parse to daily for no option' do
      recurrence = { type: :daily }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Daily')
    end

    it 'should parse to every 2 days' do
      recurrence = { type: :daily, options: { interval: 2 } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Every 2 days')
    end
  end
end