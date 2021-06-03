class Plan < ApplicationRecord
  validates :description,
            :weekly_frequency,
            presence: true

  validates :weekly_frequency,
            numericality: 
            {only_integer: true,
            greater_than_or_equal_to: 1,
            less_than_or_equal_to: 12}
end
