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
end
