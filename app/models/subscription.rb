class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :tea_subscriptions
  has_many :teas, through: :tea_subscriptions

  validates :user_id,
            :status,
            :process_on_date,
            :plan_id,
            presence: true

  enum status: [:active, :cancelled, :paused]

  scope :with_plan, -> { includes(:plan) }

  # def with_plan
  #   self.class.with_plan.where(id: id).first
  # end
end
