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

  describe '#declined_participants!' do
    context 'when maximum_participants and participants_count are zero' do
      it 'does not decrement ' do
        meeting = create(:meeting, maximum_participants: 0, participants_count: 0)
        expect { meeting.decrement_participants! }.to_not change { meeting.participants_count }
      end
    end

    context 'when maximum_participants is greater than zero, but participants_count is zero' do
      it 'does not decrement ' do
        meeting = create(:meeting, maximum_participants: 5, participants_count: 0)
        expect { meeting.decrement_participants! }.to_not change { meeting.participants_count }
      end
    end

    context 'when maximum_participants and participants_count is greater than zero' do
      it 'decrements the participants_count' do
        meeting = create(:meeting, maximum_participants: 5, participants_count: 5)
        expect { meeting.decrement_participants! }.to change { meeting.participants_count }.by(-1)
      end
    end
  end

  describe '#increment_participants!' do
    context 'when maximum_participants is zero' do
      it 'does not increment ' do
        meeting = create(:meeting, maximum_participants: 0, participants_count: 0)
        expect { meeting.increment_participants! }.to_not change { meeting.participants_count }
      end
    end

    context 'when maximum_participants is greater than zero and participants_count is zero' do
      it 'increments ' do
        meeting = create(:meeting, maximum_participants: 5, participants_count: 0)
        expect { meeting.increment_participants! }.to change { meeting.participants_count }.by(1)
      end
    end
  end

  context 'when has invitation recurrence' do
    let(:creator) { create(:user) }
    let(:invitee) { create(:user) }
    let(:meeting) { build(:meeting, creator: creator, date: '2017-05-31') }
    let(:rule_for_every_wednesday) do
      IceCube::Schedule.new(Time.zone.parse('2017-05-30T16:30')) do |schedule|
        schedule.add_recurrence_rule(IceCube::Rule.weekly.day(:wednesday))
      end
    end
    let(:rule_for_every_tuesday) do
      IceCube::Schedule.new(Time.zone.parse('2017-05-30T16:30')) do |schedule|
        schedule.add_recurrence_rule(IceCube::Rule.weekly.day(:tuesday))
      end
    end

    context 'and matches with meeting date' do
      before { InvitationRecurrence.create(creator: creator, user: invitee, rule: rule_for_every_wednesday) }

      it 'should save the meeting' do
        expect { meeting.save! }.to change(Meeting, :count).by(1)
      end

      it 'should create an invitation' do
        expect { meeting.save! }.to change(Invitation, :count).by(1)
      end
    end

    context 'and does not match with meeting date' do
      before { InvitationRecurrence.create(creator: creator, user: invitee, rule: rule_for_every_tuesday) }

      it 'should save the meeting' do
        expect { meeting.save! }.to change(Meeting, :count).by(1)
      end

      it 'should should not create an invitation' do
        expect { meeting.save! }.to_not change(Invitation, :count)
      end
    end
  end
end
