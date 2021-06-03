class UserSubscription
  attr_reader :id,
              :user_id,
              :name,
              :process_on_date,
              :weekly_frequency,
              :status,
              :teas

  def initialize(data)
    @id = data.id
    @user_id = data.user_id
    @name = data.name
    @process_on_date = data.process_on_date.strftime("%Y-%m-%d")
    @weekly_frequency = data.plan_description
    @status = data.status
    @teas = get_teas(data)
  end

  def get_teas(data)
    data.tea_subscriptions.map do |tea_subscription|
      {
        tea_id: tea_subscription.tea_id,
        title: tea_subscription.tea.title,
        box_count: tea_subscription.tea.box_count,
        quantity: tea_subscription.quantity,
        unit_price: tea_subscription.current_price,
        total_price: tea_subscription.total_price,
        status: tea_subscription.status
        }
    end
  end
end
