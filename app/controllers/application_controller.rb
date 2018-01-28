class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    api_error(e.message, ApiResponseCode::NOT_FOUND_ERROR, 404)
  end

  rescue_from ValidationError, ActiveRecord::RecordInvalid do |e|
    api_error(e.message, ApiResponseCode::VALIDATION_ERROR, 422)
  end

  def api_error(message, status, code)
    render json: { error: message, code: code }, status: status
  end
end
