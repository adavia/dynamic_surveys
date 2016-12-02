class SessionsController < ApplicationController
  before_action :is_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or [current_user, :customers]
    else
      flash.now[:danger] = "Your credentials are not valid. Try that again."
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url,
      flash: { success: "See you later!" }
  end
end
