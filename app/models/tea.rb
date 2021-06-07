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

  scope :active_distinct, -> { distinct.where('tea_subscriptions.status = 0').order(:title) }

  def self.find_by_brew_temp_and_time(query_params)
    min_temp, max_temp, min_time, max_time = query_params
    active_distinct
    .where('temperature >= ?', min_temp)
    .where('temperature <= ?', max_temp)
    .where('brew_time >= ?', min_time)
    .where('brew_time <= ?', max_time)
  end
end
