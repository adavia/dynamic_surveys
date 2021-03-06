class UsersController < ApplicationController
  before_action :is_logged_in, only: [:new, :create]
  before_action :set_user, only: [:edit, :update]

  layout 'account', only: [:new, :create]

  def show
    respond_to do |format|
      format.html {}
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url,
          flash: { success: t("app.user.new.alert")}}
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

  def edit
    add_breadcrumb "#{@user.to_s}", user_path(@user)
    add_breadcrumb t("app.user.breadcrumbs.update"), edit_user_path(@user)
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?

    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to current_user,
          flash: { success: t("app.user.edit.alert")}}
        format.js   {}
        format.json {
          render json: current_user, status: :created, location: current_user
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: current_user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :email, :remove_image,
      :password, :password_confirmation, :image, :image_cache)
  end
end
