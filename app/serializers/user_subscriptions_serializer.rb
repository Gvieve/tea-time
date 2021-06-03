class UserSubscriptionsSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :id,
              :subscriptions
end
