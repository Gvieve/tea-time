class UserSubscriptions
  attr_reader :id,
              :subscriptions

  def initialize(data)
    @id = data.first.user_id
    @subscriptions = get_subscriptions(data)
  end

  def get_subscriptions(subscription)
    subscription.map do |subscription|
      UserSubscription.new(subscription)
    end
  end
end
