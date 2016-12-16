class API::SessionsController < API::ApplicationController
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.active_for_authentication?
        render json: @user, status: 200
      else
        render json: { errors: "Your account has been locked." }, status: 422
      end
    else
      render json: { errors: "Your credentials are not valid. Try that again." }, status: 422
    end
  end
end
