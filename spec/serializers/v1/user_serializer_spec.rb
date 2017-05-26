require 'rails_helper'

RSpec.describe V1::UserSerializer, type: :serializer do
  before(:all) do
    @user = create(:user)

    serializer = V1::UserSerializer.new(@user)
    @serialization = ActiveModelSerializers::Adapter.create(serializer)
  end

  subject { JSON.parse(@serialization.to_json) }

  it 'should have id key' do
    expect(subject['user']).to have_key('id')
  end

  it 'should have name key' do
    expect(subject['user']).to have_key('name')
  end

  it 'should have a link to inventory' do
    expect(subject['user']['links']['self']).to eql(v1_user_path(@user.id))
  end
end