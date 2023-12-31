require 'rails_helper'

RSpec.describe Recurrence::Creator do
  let(:params) { {} }

  subject { described_class.new(:weekly, params) }

  before { @rule = subject.create }

  describe '#create' do
    it 'creates a weekly rule' do
      rule = described_class.new(:weekly).create
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
    end

    it 'should parse to weekly for no option' do
      rule = described_class.new(:weekly, {}).create
      expect(rule.to_s).to eq('Weekly')
    end

    it 'should parse to every 2 days' do
      recurrence = { type: :weekly, options: { interval: '2' } }
      rule = described_class.new(:weekly, recurrence).create
      expect(rule.to_s).to eq('Every 2 weeks')
    end

    it 'should parse to weekly on mondays' do
      recurrence = { type: :weekly, options: { day: ['monday'] } }
      rule = described_class.new(:weekly, recurrence).create
      expect(rule.to_s).to eq('Weekly on Mondays')
    end

    it 'should parse to weekly on mondays and tuesdays' do
      recurrence = { type: :weekly, options: { day: %w(monday tuesday) } }
      rule = described_class.new(:weekly, recurrence).create
      expect(rule.to_s).to eq('Weekly on Mondays and Tuesdays')
    end

    it 'should parse to every 2 weeks on mondays and tuesdays' do
      recurrence = { type: :weekly, options: { interval: '2', day: %w(monday tuesday) } }
      rule = described_class.new(:weekly, recurrence).create
      expect(rule.to_s).to eq('Every 2 weeks on Mondays and Tuesdays')
    end
  end
end