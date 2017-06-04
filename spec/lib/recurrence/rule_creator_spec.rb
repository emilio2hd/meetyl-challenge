require 'rails_helper'

RSpec.describe Recurrence::RuleCreator do
  it 'should create an icecube rule' do
    rule = subject.create(type: 'monthly')
    expect(rule).to_not be_nil
    expect(rule).to be_a(IceCube::MonthlyRule)
  end

  it 'should check if the creator exist' do
    expect(subject.creator?(:weekly)).to be_truthy
  end
end