class UserProfile < ApplicationRecord
  belongs_to :user

  validates :user_id,
            :first_name,
            :last_name,
            :street_address,
            :city,
            :state,
            :zipcode,
            presence: true
end
