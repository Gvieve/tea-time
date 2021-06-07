class Tea < ApplicationRecord
  has_many :tea_subscriptions
  has_many :subscriptions, through: :tea_subscriptions
  has_many :users, through: :subscriptions

  validates :title,
            :description,
            :temperature,
            :brew_time,
            :box_count,
            :price,
            presence: true

  validates_uniqueness_of :title, scope: :box_count

  def self.active_distinct
    distinct
    .where("tea_subscriptions.status = 0")
    .order(:title)
  end
end
