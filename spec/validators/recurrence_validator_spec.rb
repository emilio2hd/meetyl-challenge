require 'rails_helper'

RSpec.describe RecurrenceValidator do
  describe 'Recurrent Invitation' do
    let(:invitation) { build(:invitation) }
    let(:recurrence) { '' }

    before do
      invitation.recurrence = recurrence
      subject.validate(invitation)
    end

    context 'with invalid recurrence value' do
      let(:recurrence) { '1' }

      it 'contains error for invalid hash' do
        expect(invitation.errors).to_not be_empty
        expect(invitation.errors[:recurrence]).to eq(['It must be a valid hash'])
      end
    end

    context 'with invalid recurrence type' do
      let(:recurrence) { { 'type': 'hourly' } }

      it 'contains error for unsupported recurrence type' do
        expect(invitation.errors).to_not be_empty
        expect(invitation.errors[:recurrence]).to eq(["The type 'hourly' is not supported"])
      end
    end

    context 'with invalid recurrence start_time empty' do
      let(:recurrence) { { 'type': 'weekly', start_time: '' } }

      it 'contains error for invalid start_time' do
        expect(invitation.errors).to_not be_empty
        expect(invitation.errors[:recurrence]).to eq(['start_time is not a valid datetime'])
      end
    end

    context 'with invalid recurrence has end_time higher then start_time' do
      let(:recurrence) { { 'type': 'weekly', start_time: '2017-06-01', end_time: '2017-05-30' } }

      it 'contains error about end_time higher than start_time' do
        expect(invitation.errors).to_not be_empty
        expect(invitation.errors[:recurrence]).to eq(['end_time must be higher than start_time'])
      end
    end

    context 'with bad occurrence options' do
      let(:recurrence) { { 'type' => 'weekly', 'options' => { 'day' => ['january'] } } }

      it 'contains error for malformed recurrence' do
        expect(invitation.errors).to_not be_empty
        expect(invitation.errors[:recurrence]).to eq(['Recurrence options lead to a malformed recurrence'])
      end
    end

    context 'with valid recurrence' do
      let(:recurrence) { { 'type': 'daily' } }

      it 'contains no error' do
        expect(invitation.errors).to be_empty
      end
    end
  end
end