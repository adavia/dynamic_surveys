class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :archive]
  before_action :set_customers, only: [:new, :create, :edit, :update]

  def index
    @users = User.excluding_archived.paginate(page: params[:page])
  end

  def show
    add_breadcrumb t("app.user.breadcrumbs.list"), :admin_users_path
    add_breadcrumb "#{@user.to_s}", admin_user_path(@user)
  end

  def new
    @user = User.new
    add_breadcrumb t("app.user.breadcrumbs.list"), :admin_users_path
    add_breadcrumb t("app.user.breadcrumbs.new"), new_admin_user_path
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      build_roles_for(@user)
      if @user.save
        format.html { redirect_to [:admin, :users],
          flash: { success: t("app.user.admin_new.alert")}}
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
    add_breadcrumb t("app.user.breadcrumbs.list"), :admin_users_path
    add_breadcrumb "#{@user.to_s}", admin_user_path(@user)
    add_breadcrumb t("app.user.breadcrumbs.update"), edit_admin_user_path(@user)
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?

    respond_to do |format|
      User.transaction do
        @user.roles.clear
        build_roles_for(@user)
        if @user.update(user_params)
          format.html { redirect_to [:admin, :users],
            flash: { success: t("app.user.admin_edit.alert")}}
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
  end

  def archive
    if @user == current_user
      flash[:danger] = t("app.user.archive.fail")
    else
      @user.archive
      flash[:success] = t("app.user.archive.success")
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

  def set_customers
    @customers = Customer.includes(:surveys).order(:name)
  end

  def build_roles_for(user)
    role_data = params.fetch(:roles, [])
    role_data.each do |customer_id, role_name|
      if role_name.present?
        user.roles.build(customer_id: customer_id, role: role_name)
      end
    end
  end
end
