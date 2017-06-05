FactoryGirl.define do
  factory :invitation_recurrence, class: InvitationRecurrence do
    association :creator, factory: :user
    association :user, factory: :user
    rule { IceCube::Schedule.new { |schedule| schedule.add_recurrence_rule IceCube::Rule.monthly } }
  end

  factory :daily_invitation_recurrence, class: InvitationRecurrence do
    association :creator, factory: :user
    association :user, factory: :user
    rule { IceCube::Schedule.new { |schedule| schedule.add_recurrence_rule IceCube::Rule.daily } }
  end
end