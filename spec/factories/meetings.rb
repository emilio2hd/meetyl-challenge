FactoryGirl.define do
  factory :meeting, class: Meeting do
    place { FFaker::Address.street_address }
    date { '2017-05-05' }
    time { '10:00' }
    maximum_participants 0

    association :creator, factory: :user
  end
end