class Api::V1::TeaSubscriptionsController < ApplicationController

  def index
    data = user.teas.active_distinct if user
    tea_subscriptions = UserTeaSubscriptions.new(user, data)
    render_success (UserTeaSubscriptionsSerializer.new(tea_subscriptions))
  end
end
