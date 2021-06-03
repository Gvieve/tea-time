module Validate
  def missing_params(required)
    !required.all? {|key| params.has_key?(key)}
  end

  def user
    User.find(params[:user_id])
  end
end
