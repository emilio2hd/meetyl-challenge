require 'rails_helper'

RSpec.describe InvitationRecurrence, type: :model do
  it { is_expected.to validate_presence_of(:rule) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:creator) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:creator).class_name('User').with_foreign_key('creator_id') }

  it 'should serialize rule and save' do
    creator = create(:user)

    recurrence = create(:daily_invitation_recurrence, creator: creator)

    last_rule = InvitationRecurrence.find_by(creator: creator)
    expect(last_rule.rule).to eq(recurrence.rule)
  end
end
