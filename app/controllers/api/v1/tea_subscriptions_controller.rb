class Api::V1::TeaSubscriptionsController < ApplicationController

  def index
    if user && (brew_temp || brew_time)
      # query_params = [min_brew_temp, max_brew_temp, min_brew_time, max_brew_time]
      data = user.teas.find_by_brew_temp_and_time(query_params)
    else
      data = user.teas.active_distinct if user
    end
    tea_subscriptions = UserTeaSubscriptions.new(user, data)
    render_success (UserTeaSubscriptionsSerializer.new(tea_subscriptions))
  end
end
