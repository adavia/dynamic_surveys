class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  protected

  # Confirms a logged-in user.
  def authenticate_user
    unless logged_in?
      store_location
      redirect_to new_session_url
      flash[:info] = "You must be logged in to perform this action."
    end
  end

  # Check user is already logged in
  def is_logged_in
    if logged_in?
      redirect_to [current_user, :customers]
    end
  end
end
