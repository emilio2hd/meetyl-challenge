require 'rails_helper'
require 'recurrence/translator'

RSpec.describe Recurrence::Translator do
  # rubocop:disable Style/IndentHash
  describe '#daily' do
    it 'should parse to daily for no option' do
      recurrence = { recurrence: :daily }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::DailyRule)
      expect(rule.to_s).to eq('Daily')
    end

    it 'should parse to every 2 days' do
      recurrence = { recurrence: :daily, options: { interval: 2 } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::DailyRule)
      expect(rule.to_s).to eq('Every 2 days')
    end
  end

  describe '#weekly' do
    it 'should parse to weekly for no option' do
      recurrence = { recurrence: :weekly }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
      expect(rule.to_s).to eq('Weekly')
    end

    it 'should parse to every 2 days' do
      recurrence = { recurrence: :weekly, options: { interval: '2' } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
      expect(rule.to_s).to eq('Every 2 weeks')
    end

    it 'should parse to weekly on Mondays' do
      recurrence = { recurrence: :weekly, options: { day: ['monday'] } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
      expect(rule.to_s).to eq('Weekly on Mondays')
    end

    it 'should parse to weekly on Mondays and Tuesdays' do
      recurrence = { recurrence: :weekly, options: { day: %w(monday tuesday) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
      expect(rule.to_s).to eq('Weekly on Mondays and Tuesdays')
    end

    it 'should parse to every 2 days' do
      recurrence = { recurrence: :weekly, options: { interval: '2', day: %w(monday tuesday) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::WeeklyRule)
      expect(rule.to_s).to eq('Every 2 weeks on Mondays and Tuesdays')
    end
  end

  describe '#monthly' do
    it 'should parse to monthly for no option' do
      recurrence = { recurrence: 'monthly' }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Monthly')
    end

    it 'should parse to every 2 months' do
      recurrence = { recurrence: 'monthly', options: { interval: '2' } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Every 2 months')
    end

    it 'should parse to monthly on the 10th day of the month' do
      recurrence = { recurrence: 'monthly', options: { day_of_month: %w(10) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Monthly on the 10th day of the month')
    end

    it 'should parse to monthly on the 1st and 2nd days of the month' do
      recurrence = { recurrence: 'monthly', options: { day_of_month: %w(1 2) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Monthly on the 1st and 2nd days of the month')
    end

    it 'should parse to monthly on the 1st Tuesday and 10th Tuesday' do
      recurrence = { recurrence: 'monthly', options: { day_of_week: { tuesday: %w(1 10) } } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Monthly on the 1st Tuesday and 10th Tuesday')
    end

    it 'should parse to monthly on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday' do
      recurrence = { recurrence: 'monthly', options: { day_of_month: %w(1 2), day_of_week: { tuesday: %w(1 10) } } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Monthly on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday')
    end

    it 'should parse to every 2 months on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday' do
      recurrence = { recurrence: 'monthly', options: { interval: '2', day_of_month: %w(1 2), day_of_week: { tuesday: %w(1 10) } } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::MonthlyRule)
      expect(rule.to_s).to eq('Every 2 months on the 1st and 2nd days of the month on the 1st Tuesday and 10th Tuesday')
    end

  end

  describe '#yearly' do
    it 'should parse to yearly for no option' do
      recurrence = { recurrence: 'yearly' }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Yearly')
    end

    it 'should parse to every 2 months' do
      recurrence = { recurrence: 'yearly', options: { interval: '2' } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Every 2 years')
    end

    it 'should parse to yearly on the 100th and -100th to last days of the year' do
      recurrence = { recurrence: 'yearly', options: { day_of_year: %w(100 -100) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Yearly on the 100th and -100th to last days of the year')
    end

    it 'should parse to yearly in January and February' do
      recurrence = { recurrence: 'yearly', options: { month_of_year: %w(january february) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Yearly in January and February')
    end

    it 'should parse to every 2 years on the 100th and -100th to last days of the year' do
      recurrence = { recurrence: 'yearly', options: { interval: '2', day_of_year: %w(100 -100) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Every 2 years on the 100th and -100th to last days of the year')
    end

    it 'should parse to every 2 years in January and February' do
      recurrence = { recurrence: 'yearly', options: { interval: '2', month_of_year: %w(january february) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Every 2 years in January and February')
    end

    it 'should parse to every 2 years on the 100th and -100th to last days of the year in January and February' do
      recurrence = { recurrence: 'yearly', options: { interval: '2', day_of_year: %w(100 -100), month_of_year: %w(january february) } }
      rule = Recurrence::Translator.parse(recurrence)
      expect(rule).to be_kind_of(IceCube::YearlyRule)
      expect(rule.to_s).to eq('Every 2 years on the 100th and -100th to last days of the year in January and February')
    end
  end
end