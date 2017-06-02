require 'rails_helper'
require 'recurrence/creator/yearly'

RSpec.describe Recurrence::Creator::Yearly do
  it 'creates a yearly rule' do
    rule = described_class.new({}).create
    expect(rule).to be_kind_of(IceCube::YearlyRule)
  end

  describe '#create' do
    it 'should parse to yearly for no option' do
      recurrence = { type: 'yearly' }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Yearly')
    end

    it 'should parse to every 2 months' do
      recurrence = { type: 'yearly', options: { interval: '2' } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Every 2 years')
    end

    it 'should parse to yearly on the 100th and -100th to last days of the year' do
      recurrence = { type: 'yearly', options: { day_of_year: %w(100 -100) } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Yearly on the 100th and -100th to last days of the year')
    end

    it 'should parse to yearly in January and February' do
      recurrence = { type: 'yearly', options: { month_of_year: %w(january february) } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Yearly in January and February')
    end

    it 'should parse to every 2 years on the 100th and -100th to last days of the year' do
      recurrence = { type: 'yearly', options: { interval: '2', day_of_year: %w(100 -100) } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Every 2 years on the 100th and -100th to last days of the year')
    end

    it 'should parse to every 2 years in January and February' do
      recurrence = { type: 'yearly', options: { interval: '2', month_of_year: %w(january february) } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Every 2 years in January and February')
    end

    it 'should parse to every 2 years on the 100th and -100th to last days of the year in January and February' do
      recurrence = { type: 'yearly', options: { interval: '2', day_of_year: %w(100 -100), month_of_year: %w(january february) } }
      rule = described_class.new(recurrence).create
      expect(rule.to_s).to eq('Every 2 years on the 100th and -100th to last days of the year in January and February')
    end
  end
end