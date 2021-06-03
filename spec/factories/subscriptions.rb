FactoryBot.define do
  factory :subscription do
    user
    name { "MyString" }
    status { [0, 1, 2].sample }
    plan
    process_on_date { Faker::Date.between(from: 14.days.from_now, to: 1.year.from_now) }
  end
end
