class Tea < ApplicationRecord
  validates :title,
            :description,
            :temperature,
            :brew_time,
            :box_count,
            :price,
            :presence true
  validates_uniqueness_of :title, scope: :box_count
end
