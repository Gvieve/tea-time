class Api::V1::SubscriptionsController < ApplicationController
  def create
    return render_error("Required parameter missing") if missing_params(required_create)
    # plan = Plan.find_by!(weekly_frequency: params[:weekly_frequency])
    subscription = Subscription.new(subscription_params) if user && plan
    params[:plan_id] = plan.id
    if subscription.save
      TeaSubscription.create_tea_subscriptions(subscription, params) if !params[:teas].nil?
      subscriptions = UserSubscription.new(subscription)
      render_success(UserSubscriptionSerializer.new(subscriptions))
    end
  end

  def update
    return render_error("Required parameter missing") if params[:status].nil?
    if user && subscription && plan
      params[:plan_id] = plan.id
      subscription.update(update_params)
      TeaSubscription.update_all(subscription, params) if !params[:teas].nil?
      subscriptions = UserSubscription.new(subscription)
      render_success(UserSubscriptionSerializer.new(subscriptions))
    end
  end

  private

  def required_create
    [:user_id, :process_on_date, :weekly_frequency, :teas]
  end

  def subscription_params
    params.permit(:user_id, :plan_id, :name, :process_on_date)
  end

  def update_params
    params.permit(:plan_id, :name, :process_on_date)
  end
end
