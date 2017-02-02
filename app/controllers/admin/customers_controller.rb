class Admin::CustomersController < Admin::ApplicationController
  before_action :set_customer, only: [:edit, :update, :archive]

  def new
    @customer = Customer.new
    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb t("app.customer.breadcrumbs.new"), new_admin_user_customer_path
  end

  def create
    @customer = current_user.customers.build(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_url,
          flash: { success: t("app.customer.new.alert")}}
        format.js   {}
        format.json { render json: @customer,
          status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.js   {}
        format.json { render json: @customer.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def edit
    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name}", customer_path(@customer)
    add_breadcrumb t("app.customer.breadcrumbs.update"), edit_admin_user_customer_path(current_user, @customer)
  end

  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_url,
          flash: { success: t("app.customer.edit.alert")}}
        format.js   {}
        format.json {
          render json: @customer, status: :created, location: @customer
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @customer.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def archive
    @customer.archive
    respond_to do |format|
      format.html { redirect_to customers_url,
          flash: { success: t("app.customer.archive.alert")}}
      format.js {}
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :description)
  end

  def set_customer
    @customer = Customer.includes(:surveys, :user).find(params[:id])
  end
end
