require 'rails_helper'
require 'invitation/action/accept'

RSpec.describe Invitation::Action::Accept do
  describe '#execute!' do
    let(:invitation) { create(:invitation) }

    context 'when record is valid' do
      before do
        @result = subject.execute!(invitation)
        invitation.reload
      end

      it 'should return an action result' do
        expect(@result).to be_kind_of(Invitation::Action::ActionResult)
      end

      it 'should change the status to accepted' do
        expect(invitation.status).to eq('accepted')
      end
    end

    context 'when record is invalid' do
      let(:invitation) { Invitation.new }

      before do
        invitation.errors.add(:base, :some_error, message: 'some message error')
        allow(invitation).to receive(:errors).and_return(ActiveModel::Errors.new(invitation))

        exception = ActiveRecord::RecordInvalid.new(invitation)
        allow(invitation).to receive(:accepted!).and_raise(exception)

        @result = subject.execute!(invitation)
      end

      it 'should return an action result' do
        expect(@result).to be_kind_of(Invitation::Action::ActionResult)
      end

      it 'should a result with error' do
        expect(@result.error?).to be_truthy
      end
    end
  end
end