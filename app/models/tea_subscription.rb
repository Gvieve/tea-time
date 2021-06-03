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
end
