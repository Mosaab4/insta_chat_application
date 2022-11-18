class ApplicationController < ActionController::API
  def not_found_response
    render json: {
      status: false,
      message: "Not Found",
      data: {},
      meta: {}
    }, status: :not_found
  end

  def validation_error(field)
    render json: {
      status: false,
      message: "Validation Error",
      data: {
        error: field + " can not be empty",
      },
      meta:{}
    }, status: :unprocessable_entity
  end

  def error_response(error)
    render json: {
      status: false,
      message: error,
      data: {
        error: error,
      },
      meta:{}
    }, status: :unprocessable_entity
  end

  def success_response(data, meta = {}, code = 200, message = "Success", status = true)
    render json: {
      status: status,
      message: message,
      data: data,
      meta: meta
    }, status: code
  end
end
