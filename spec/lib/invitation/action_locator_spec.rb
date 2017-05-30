require 'rails_helper'
require 'invitation/action_locator'

RSpec.describe Invitation::ActionLocator do
  let(:expected_actions) do
    { accept: Invitation::Action::Accept,
      decline: Invitation::Action::Decline }
  end

  it 'should contains actions registred' do
    actions = subject.instance_variable_get(:@actions)

    actions.each do |key, value|
      expect(expected_actions).to have_key(key)
      expect(expected_actions[key]).to eq(value)
    end
  end

  it 'should return an action instance' do
    action = subject.lookup('accept')
    expect(action).to_not be_nil
    expect(action).to be_a(Invitation::Action::Accept)
  end

  it 'should check if the action exist' do
    expect(subject.has_action?(:decline)).to be_truthy
  end
end