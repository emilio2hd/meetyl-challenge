require 'rails_helper'

RSpec.describe V1::MeetingSerializer, type: :serializer do
  before(:all) do
    @meeting = create(:meeting)
    serializer = V1::MeetingSerializer.new(@meeting)
    @serialization = ActiveModelSerializers::Adapter.create(serializer)
  end

  subject { JSON.parse(@serialization.to_json) }

  it 'should have id key' do
    expect(subject['meeting']).to have_key('id')
  end

  it 'should have place key' do
    expect(subject['meeting']).to have_key('place')
  end

  it 'should have date key' do
    expect(subject['meeting']).to have_key('date')
  end

  it 'should have time key' do
    expect(subject['meeting']).to have_key('time')
  end

  it 'should have creator key' do
    expect(subject['meeting']).to have_key('creator')
  end

  it 'should have a link to inventory' do
    expect(subject['meeting']['links']['self']).to eql(v1_user_meeting_path(@meeting.creator_id, @meeting.id))
  end
end