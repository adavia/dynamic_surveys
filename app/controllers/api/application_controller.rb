class API::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

  attr_reader :current_user

  protected

  def authenticate_user
    authenticate_token || not_authorized
  end

  def authenticate_token
    authenticate_with_http_token do |token|
      @current_user = Customer.find_by(api_key: token)
    end
  end

  def not_authorized
    render json: { error: "Unauthorized" }, status: 403
  end
end
