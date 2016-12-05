class UsersController < ApplicationController
  before_action :is_logged_in

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url,
          flash: { success: "Your account has been created successfully!"}}
        format.js   {}
        format.json { render json: @user,
          status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json {
          render json: @user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :last_name, :email, :password, :password_confirmation)
  end
end
