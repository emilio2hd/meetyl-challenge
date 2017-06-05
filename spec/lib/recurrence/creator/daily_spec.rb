require 'rails_helper'

RSpec.describe Recurrence::Creator do
  describe '#create' do
    it 'creates a daily rule' do
      rule = described_class.new(:daily).create
      expect(rule).to be_kind_of(IceCube::DailyRule)
    end

    it 'should parse to daily for no option' do
      rule = described_class.new(:daily, {}).create
      expect(rule.to_s).to eq('Daily')
    end

    it 'should parse to every 2 days' do
      recurrence = { type: :daily, options: { interval: 2 } }
      rule = described_class.new(:daily, recurrence).create
      expect(rule.to_s).to eq('Every 2 days')
    end
  end
end