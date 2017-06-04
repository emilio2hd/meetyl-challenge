require 'rails_helper'

RSpec.describe Recurrence::Creator do
  it 'creates a monthly rule' do
    rule = described_class.new(:monthly).create
    expect(rule).to be_kind_of(IceCube::MonthlyRule)
  end

  describe '#create' do
    it 'should parse to monthly for no option' do
      rule = described_class.new(:monthly, {}).create
      expect(rule.to_s).to eq('Monthly')
    end

    it 'should parse to every 2 months' do
      recurrence = { type: 'monthly', options: { interval: '2' } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Every 2 months')
    end

    it 'should parse to monthly on the 10th day of the month' do
      recurrence = { type: 'monthly', options: { day_of_month: %w(10) } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Monthly on the 10th day of the month')
    end

    it 'should parse to monthly on the 1st and 2nd days of the month' do
      recurrence = { type: 'monthly', options: { day_of_month: %w(1 2) } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Monthly on the 1st and 2nd days of the month')
    end

    it 'should parse to monthly on the 1st Tuesday and 10th Tuesday' do
      recurrence = { type: 'monthly', options: { day_of_week: { tuesday: %w(1 10) } } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Monthly on the 1st Tuesday and 10th Tuesday')
    end

    it 'should parse to monthly on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday' do
      recurrence = { type: 'monthly', options: { day_of_month: %w(1 2), day_of_week: { tuesday: %w(1 10) } } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Monthly on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday')
    end

    it 'should parse to every 2 months on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday' do
      recurrence = { type: 'monthly', options: { interval: '2', day_of_month: %w(1 2), day_of_week: { tuesday: %w(1 10) } } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Every 2 months on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday')
    end

    it 'should parse to monthly on Fridays on the 13th day of the month' do
      recurrence = { type: 'monthly', options: { day: %w(friday), day_of_month: %w(13) } }
      rule = described_class.new(:monthly, recurrence).create
      expect(rule.to_s).to eq('Monthly on Fridays on the 13th day of the month')
    end
  end
end