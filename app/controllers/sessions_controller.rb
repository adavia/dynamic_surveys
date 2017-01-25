class SessionsController < ApplicationController
  before_action :is_logged_in, only: [:new, :create]

  layout 'account'

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.active_for_authentication?
        log_in user
        redirect_back_or customers_url
      else
        flash.now[:danger] = t("app.session.create.alert_locked")
        render :new
      end
    else
      flash.now[:danger] = t("app.session.create.alert_valid")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to new_session_url,
      flash: { success: t("app.session.destroy.alert") }
  end
end
