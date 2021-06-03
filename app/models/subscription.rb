class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :user_id,
            :status,
            :process_on_date,
            :plan_id,
            presence: true

  enum status: [:active, :cancelled, :paused]

  before_create {self.status = 'active'}
end
