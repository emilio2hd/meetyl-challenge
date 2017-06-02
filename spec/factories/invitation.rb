FactoryGirl.define do
  factory :invitation, class: Invitation do
    association :meeting, factory: :meeting
    association :invitee, factory: :user
    recurrent false

    factory :recurrent_invitation, class: Invitation do
      recurrent true
    end

    factory :accepted_invitation, class: Invitation do
      status :accepted
    end

    factory :recurrent_accepted_invitation, class: Invitation do
      status :accepted
      recurrent true
    end
  end
end