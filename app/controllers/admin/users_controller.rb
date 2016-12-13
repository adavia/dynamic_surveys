class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :archive]

  def index
    @users = User.excluding_archived.order(:email)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, :users],
          flash: { success: "The user has been created successfully."}}
        format.js   {}
        format.json { render json: @user,
          status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json { render json: @user.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, :users],
          flash: { success: "The user has been updated successfully."}}
        format.js   {}
        format.json {
          render json: @user, status: :created, location: @user
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def archive
    if @user == current_user
      flash[:danger] = "You cannot archive yourself!"
    else
      @user.archive
      flash[:success] = "User has been archived."
    end

    redirect_to [:admin, :users]
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :email, :admin, :password)
  end
end
