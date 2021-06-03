class ApplicationController < ActionController::API
  include Response
  include Validate

  rescue_from ActiveRecord::RecordNotFound, with: :render_exception
  rescue_from ActiveRecord::RecordInvalid, with: :render_exception
end
