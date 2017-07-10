class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  private
  def render_error_with_message(message, status)
    render json: {
      success: false,
      message: message
    }, status: status
  end
end
