class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  include Pundit
  include SessionsHelper

  #after_action :verify_authorized, except: [:index],
    #unless: :sessions_controller?
  #after_action :verify_policy_scoped, only: [:index],
    #unless: :sessions_controller?

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  # Confirms a logged-in user.
  def authenticate_user
    unless logged_in?
      store_location
      redirect_to new_session_url
      flash[:info] = t("app.alert_auth")
    end
  end

  # Check user is already logged in
  def is_logged_in
    if logged_in?
      redirect_to customers_url
    end
  end

  def not_authorized
    redirect_to customers_url
    flash[:info] = t("app.alert_permission")
  end

  def record_not_found
    redirect_to customers_url
    flash[:info] = t("app.alert_404")
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options(options = {})
    { locale: I18n.locale }
  end
end
