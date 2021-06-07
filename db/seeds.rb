Plan.destroy_all
UserProfile.destroy_all
TeaSubscription.destroy_all
Subscription.destroy_all
Tea.destroy_all
User.destroy_all

#reset pk sequences back to 1
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

@user = FactoryBot.create(:user)
@plan_4 = FactoryBot.create(:plan, weekly_frequency: 4)
@plan_6 = FactoryBot.create(:plan, weekly_frequency: 6)
@subscription = FactoryBot.create(:subscription, user: @user, plan: @plan_4)
@subscription_2 = FactoryBot.create(:subscription, user: @user, plan: @plan_6)
@tea_1 = FactoryBot.create(:tea, temperature: 195, brew_time: 7)
@tea_2 = FactoryBot.create(:tea, temperature: 202, brew_time: 4)
@tea_3 = FactoryBot.create(:tea, temperature: 190, brew_time: 5)
@tea_4 = FactoryBot.create(:tea, temperature: 175, brew_time: 10)
@tea_5 = FactoryBot.create(:tea, temperature: 212, brew_time: 6, title: "AA Tea")
@tea_subscription_1 = FactoryBot.create(:tea_subscription, tea: @tea_1, subscription: @subscription, quantity: 1, status: 'active')
@tea_subscription_2 = FactoryBot.create(:tea_subscription, tea: @tea_2, subscription: @subscription, quantity: 2, status: 'active')
@tea_subscription_3 = FactoryBot.create(:tea_subscription, tea: @tea_3, subscription: @subscription_2, quantity: 3, status: 'active')
@tea_subscription_4 = FactoryBot.create(:tea_subscription, tea: @tea_4, subscription: @subscription, quantity: 2, status: 'active')
@tea_subscription_5 = FactoryBot.create(:tea_subscription, tea: @tea_5, subscription: @subscription, quantity: 1, status: 'active')
@tea_subscription_6 = FactoryBot.create(:tea_subscription, tea: @tea_1, subscription: @subscription, quantity: 2, status: 'cancelled')
@tea_subscription_7 = FactoryBot.create(:tea_subscription, tea: @tea_1, subscription: @subscription_2, quantity: 2, status: 'active')

#reset pk sequences to max value
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
