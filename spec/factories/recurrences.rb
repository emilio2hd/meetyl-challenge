FactoryGirl.define do
  factory :recurrence, class: IceCube::Schedule do
    skip_create
    transient do
      end_time nil
      rule nil
    end

    start_time { Time.zone.now }

    after(:build) do |schedule, evaluator|
      evaluator.rule.until(evaluator.end_time) if evaluator.end_time
      schedule.add_recurrence_rule(evaluator.rule)
    end

    factory :daily_recurrence, class: IceCube::Schedule do
      transient { rule IceCube::Rule.daily }
    end
  end
end