module Response
  def render_success(object, status = :ok)
    render json: object, status: status
  end

  def render_exception(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_error(error, status = :bad_request)
    render json: { message: "your request cannot be completed", error: error, url: url}, status: status
  end

  private

  def url
    "https://github.com/Gvieve/tea-time/blob/main/API_Documentation.md"
  end
end
