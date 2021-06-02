FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { "Some tea" }
    temperature { Faker::Number.between(from: 175, to: 212) }
    brew_time { Faker::Number.between(from: 3, to: 13) }
    box_count { [1, 10, 20, 40].sample }
    price { Faker::Commerce.price(range: 5.09..65.99) }
  end
end
