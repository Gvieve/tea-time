FactoryBot.define do
  factory :tea_subscription do
    subscription
    tea
    current_price { tea.price }
    quantity { Faker::Number.between(from: 1, to: 10) }
    status { nil }
  end
end
