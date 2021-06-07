class Api::V1::SubscriptionsController < ApplicationController
  before_action :validate_parameters

  def index
    data = user.subscriptions.with_plan if user
    subscriptions = UserSubscriptions.new(data)
    render_success(UserSubscriptionsSerializer.new(subscriptions))
  end

  def create
    return render_error("Required parameter missing") if missing_params(required_create)
    params[:plan_id] = plan.id
    subscription = Subscription.new(subscription_params) if user && plan
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
