class UserSubscriptionSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :user_id,
              :name,
              :process_on_date,
              :weekly_frequency,
              :status,
              :teas
end
