class API::SessionsController < API::ApplicationController
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      render json: @user, status: 200
    else
      render json: { errors: "Your credentials are not valid. Try that again." }, status: 422
    end
  end
end
