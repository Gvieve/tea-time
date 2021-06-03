class TeaSubscription < ApplicationRecord
  belongs_to :subscription
  belongs_to :tea

  validates :tea_id,
            :subscription_id,
            :current_price,
            :quantity,
            :status,
            presence: true

  enum status: [:active, :cancelled, :paused]

  def self.create_tea_subscriptions(subscription, params)
    params[:teas].each do |tea|
      create!(
        tea_id: tea[:tea_id].to_i,
        subscription_id: subscription.id,
        current_price: Tea.find(tea[:tea_id]).price,
        quantity: tea[:quantity]
      )
    end
  end

  def total_price
    quantity * current_price
  end
end
