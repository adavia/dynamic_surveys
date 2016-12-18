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
        flash.now[:danger] = "Your account has been locked."
        render :new
      end
    else
      flash.now[:danger] = "Your credentials are not valid. Try that again."
      render :new
    end
  end

  def destroy
    log_out
    redirect_to new_session_url,
      flash: { success: "See you later!" }
  end
end
