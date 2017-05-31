require 'rails_helper'

RSpec.describe InvitationRecurrence, type: :model do
  it { is_expected.to validate_presence_of(:rule) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:creator) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:creator).class_name('User').with_foreign_key('creator_id') }

  it 'should serialize rule and save' do
    user = create(:user)
    creator = create(:user)

    schedule = IceCube::Schedule.new(Time.zone.now)
    schedule.add_recurrence_rule IceCube::Rule.daily(3)

    InvitationRecurrence.create(creator: creator, user: user, rule: schedule)

    last_rule = InvitationRecurrence.find_by(creator: creator)
    expect(last_rule.rule).to eq(schedule)
  end
end
