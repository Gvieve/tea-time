module Validate
  def missing_params(required)
    !required.all? {|key| params.has_key?(key)}
  end

  def validate_parameters
    params.each do |key, value|
      validate_id(key, value) if key.include?("id")
    end
  end

  def validate_id(key, value)
    error = "String not accepted as id"
    render_error(error) if value.to_i == 0
  end

  def min_brew_temp
    params[:min_brew_temp]
  end

  def max_brew_temp
    params[:max_brew_temp]
  end

  def brew_temp
    min_brew_temp || max_brew_temp
  end

  def min_brew_time
    params[:min_brew_time]
  end

  def max_brew_time
    params[:max_brew_time]
  end

  def brew_time
    min_brew_time || max_brew_time
  end

  def query_params
    min_temp = min_brew_temp ? min_brew_temp : 0
    max_temp = max_brew_temp ? max_brew_temp : 1_000_000
    min_time = min_brew_time ? min_brew_time : 0
    max_time = max_brew_time ? max_brew_time : 1_000_000
    [min_temp, max_temp, min_time, max_time]
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
