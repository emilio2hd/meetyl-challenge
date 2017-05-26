FactoryGirl.define do
  factory :user, class: User do
    name { FFaker::Name.first_name }
  end
end