class API::SessionsController < API::ApplicationController
  def create
    @customer = Customer.find_by(username: params[:session][:username])
    if @customer && @customer.authenticate(params[:session][:password])
      if @customer.active_for_authentication?
        render json: @customer, status: 200
      else
        render json: { errors: "Your account has been locked." }, status: 422
      end
    else
      render json: { errors: "Your credentials are not valid. Try that again." }, status: 422
    end
  end
end
