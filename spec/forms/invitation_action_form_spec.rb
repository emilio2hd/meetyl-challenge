require 'rails_helper'

RSpec.describe InvitationActionForm, type: :model do
  it { is_expected.to validate_presence_of(:action) }

  describe '#check_action_availability' do
    let(:action_name) { 'accept' }

    subject { InvitationActionForm.new(action: action_name) }

    it 'should call action locator to check action' do
      expect(Invitation::ActionLocator).to receive(:has_action?).with(action_name).and_return(true)
      expect(subject.valid?).to be_truthy
    end
  end
end