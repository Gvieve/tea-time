class UserTeaSubscriptions
  attr_reader :id,
              :tea_subscriptions

  def initialize(user, data)
    @id = user.id
    @tea_subscriptions = get_tea_subscriptions(data)
  end

  def get_tea_subscriptions(data)
    data.map {|tea| UserTeaSubscription.new(tea)}.uniq
  end
end
