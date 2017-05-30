require 'rails_helper'
require 'invitation/action/accept'

RSpec.describe Invitation::Action::Accept do
  describe '#execute!' do
    let(:invitation) { create(:invitation) }

    before do
      subject.execute!(invitation)
      invitation.reload
    end

    it 'should change the status to accepted' do
      expect(invitation.status).to eq('accepted')
    end
  end
end