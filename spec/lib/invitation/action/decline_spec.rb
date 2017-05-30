require 'rails_helper'
require 'invitation/action/decline'

RSpec.describe Invitation::Action::Decline do
  describe '#execute!' do
    let(:invitation) { create(:invitation) }

    before do
      subject.execute!(invitation)
      invitation.reload
    end

    it 'should change the status to accepted' do
      expect(invitation.status).to eq('declined')
    end
  end
end