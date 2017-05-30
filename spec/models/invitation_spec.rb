require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it { is_expected.to validate_presence_of(:meeting) }
  it { is_expected.to validate_presence_of(:invitee) }

  it { is_expected.to belong_to(:meeting) }
  it { is_expected.to belong_to(:invitee).class_name('User').with_foreign_key('invitee_id') }
  it { is_expected.to define_enum_for(:status).with([:pending, :accepted, :declined]) }

  describe 'access_code generating' do
    before do
      @invitation_attr = build(:invitation).attributes
      @invitation = Invitation.new(@invitation_attr)
      @invitation.save
    end

    it 'should generate before save' do
      expect(@invitation.access_code).to_not be_empty
    end

    it 'should contains meeting_id, invitee_id and uuid as access_code composition' do
      decoded = Base64.urlsafe_decode64(@invitation.access_code)
      meeting_id, invitee_id, uuid = decoded.split('$')

      expect(meeting_id).to eq(@invitation_attr['meeting_id'].to_s)
      expect(invitee_id).to eq(@invitation_attr['invitee_id'].to_s)
      expect(uuid).to match(/^(.+-){4}(.+)$/)
    end
  end

  describe '#accepted!' do
    it 'should change invitation status' do
      invitation = create(:invitation)
      meeting = invitation.meeting
      invitation.accepted!

      invitation.reload
      meeting.reload

      expect(invitation.status).to eq('accepted')
      expect(meeting.participants_count).to eq(1)
    end

    context 'when meeting has maximum of participants' do
      let(:meeting) { create(:meeting) }
      before { @invitation = create(:invitation, meeting: meeting) }

      context 'and the maximum has not been reached' do
        let(:meeting) { create(:meeting, maximum_participants: 2, participants_count: 1) }

        it 'should change the invitation status' do
          expect { @invitation.accepted! }.to_not raise_error
        end
      end

      context 'and the maximum has been reached' do
        let(:meeting) { create(:meeting, maximum_participants: 2, participants_count: 2) }

        it 'should not change the invitation status' do
          begin
            @invitation.accepted!
          rescue ActiveRecord::RecordInvalid
            @invitation.reload
            expect(@invitation.status).to eq('pending')
          end
        end

        it 'should raise error' do
          expect { @invitation.accepted! }
            .to raise_error(ActiveRecord::RecordInvalid)
            .with_message(/Meeting overbooked, maximum participants has been reached/)
        end
      end
    end
  end

  describe '#declined!' do
    it 'should change invitation status' do
      invitation = create(:invitation, status: :accepted)
      meeting = invitation.meeting
      meeting.increment(:participants_count)

      invitation.declined!

      invitation.reload
      meeting.reload

      expect(invitation.status).to eq('declined')
      expect(meeting.participants_count).to eq(0)
    end
  end
end
