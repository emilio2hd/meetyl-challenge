require 'rails_helper'
require 'invitation/action/decline'

RSpec.describe Invitation::Action::Decline do
  describe '#execute!' do
    let(:invitation) { create(:invitation) }

    before do
      @result = subject.execute!(invitation)
      invitation.reload
    end

    it 'should return an action result' do
      expect(@result).to be_kind_of(Invitation::Action::ActionResult)
    end

    it 'should change the status to accepted' do
      expect(invitation.status).to eq('declined')
    end
  end
end