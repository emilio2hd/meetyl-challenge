require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it { is_expected.to validate_presence_of(:place) }
  it { is_expected.to validate_presence_of(:creator) }

  it { is_expected.to validate_length_of(:place).is_at_most(255) }
  it { is_expected.to belong_to(:creator).class_name('User').with_foreign_key('creator_id') }
  it { is_expected.to allow_value('2007-05-29', '05/05/2017').for(:date) }
  it { is_expected.to allow_value('10:00').for(:time) }
  it { is_expected.to_not allow_value('', 'zzzz', '2017', '2017/30/05', '0').for(:date) }
  it { is_expected.to_not allow_value('', 'zzzz', '2017', '10').for(:time) }

  context 'with valid attributes' do
    let(:valid_attributes) { attributes_for(:meeting).merge(creator_id: create(:user).id) }

    subject { Meeting.new(valid_attributes) }

    it 'should valid' do
      expect(subject).to be_valid
    end

    it 'should successfully save' do
      expect(subject.save).to be_truthy
    end
  end

  describe '.of_user' do
    let(:user) { create(:user) }

    context 'as creator' do
      it 'should return the meeting' do
        create(:meeting, creator: user)
        expect(Meeting.of_user(user.id).count).to eq(1)
      end
    end

    context 'as invitee' do
      it 'should return the meeting' do
        create(:invitation, invitee: user)
        expect(Meeting.of_user(user.id).count).to eq(1)
      end
    end
  end
end
