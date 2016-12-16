class Admin::CustomersController < Admin::ApplicationController
  before_action :set_customer, only: [:edit, :update, :destroy]

  def new
    @customer = Customer.new
  end

  def create
    @customer = current_user.customers.build(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_url,
          flash: { success: "The customer has been created successfully."}}
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
  end

  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_url,
          flash: { success: "The customer has been updated successfully."}}
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

  def destroy
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url,
          flash: { success: "The customer has been deleted successfully."}}
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