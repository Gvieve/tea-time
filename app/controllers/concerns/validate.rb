module Validate
  def missing_params(required)
    !required.all? {|key| params.has_key?(key)}
  end

  def user
    User.find(params[:user_id])
  end

  def subscription
    Subscription.find_by!(user_id: params[:user_id], id: params[:id])
  end

  def plan
    Plan.find_by!(weekly_frequency: params[:weekly_frequency])
  end
end
