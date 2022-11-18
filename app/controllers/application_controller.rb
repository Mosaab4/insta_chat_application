class ApplicationController < ActionController::API
  def not_found_response
    render json: { meta: { status: false, message: "Not Found" } }, status: :not_found
  end

  def validation_error(field)
    render json: {
      error: field + " can not be empty" ,
      meta: {
        status: false ,
        message: "Validation Error"
      }
    }, status: :unprocessable_entity
  end
end
