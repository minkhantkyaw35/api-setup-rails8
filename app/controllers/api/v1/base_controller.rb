class Api::V1::BaseController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  after_action :track_api_access

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def record_not_found(exception)
    render json: { error: 'Record not found' }, status: :not_found
  end

  def record_invalid(exception)
    render json: { 
      error: 'Validation failed', 
      details: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  end

  def track_api_access
    track_user_activity('api_access', {
      endpoint: "#{request.method} #{request.path}",
      controller: self.class.name,
      action: action_name
    })
  end

  def render_success(data = nil, message = 'Success', status = :ok)
    response = { success: true, message: message }
    response[:data] = data if data
    render json: response, status: status
  end

  def render_error(message = 'An error occurred', status = :bad_request, details = nil)
    response = { success: false, error: message }
    response[:details] = details if details
    render json: response, status: status
  end
end
