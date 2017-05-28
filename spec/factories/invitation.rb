FactoryGirl.define do
  factory :invitation, class: Invitation do
    association :meeting, factory: :meeting
    association :invitee, factory: :user
  end
end