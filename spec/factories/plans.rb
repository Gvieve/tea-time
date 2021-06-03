FactoryBot.define do
  factory :plan do
    weekly_frequency { Faker::Number.between(from: 1, to: 12) }
    description { "Every #{weekly_frequency} weeks" }
  end
end
