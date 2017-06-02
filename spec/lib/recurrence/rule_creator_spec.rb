require 'rails_helper'
require 'recurrence/rule_creator'

RSpec.describe Recurrence::RuleCreator do
  let(:expected_creators) do
    { daily: Recurrence::Creator::Daily,
      weekly: Recurrence::Creator::Weekly,
      monthly: Recurrence::Creator::Monthly,
      yearly: Recurrence::Creator::Yearly }
  end

  it 'should contains creators registered' do
    actions = subject.instance_variable_get(:@creators)

    actions.each do |key, value|
      expect(expected_creators).to have_key(key)
      expect(expected_creators[key]).to eq(value)
    end
  end

  it 'should create an icecube rule' do
    rule = subject.create(type: 'monthly')
    expect(rule).to_not be_nil
    expect(rule).to be_a(IceCube::MonthlyRule)
  end

  it 'should check if the creator exist' do
    expect(subject.creator?(:weekly)).to be_truthy
  end
end