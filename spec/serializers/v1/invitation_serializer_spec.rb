require 'rails_helper'

RSpec.describe V1::InvitationSerializer, type: :serializer do
  before(:all) do
    @invitation = create(:invitation)
    serializer = V1::InvitationSerializer.new(@invitation)
    @serialization = ActiveModelSerializers::Adapter.create(serializer)
  end

  subject { JSON.parse(@serialization.to_json) }

  it 'should have invitee key' do
    expect(subject['invitation']).to have_key('invitee')
  end

  it 'should have a link to inventory' do
    expect(subject['invitation']['meeting_link'])
      .to eql(v1_meeting_access_url(@invitation.meeting_id, @invitation.access_code))
  end
end
