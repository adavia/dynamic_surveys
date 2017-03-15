class CustomersController < ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: :show

  def index
    @customers = policy_scope(Customer
      .excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @customers }
    end
  end

  def show
    authorize @customer, :show?
    respond_to do |format|
      format.html {}
      format.json { render json: @customer }
    end

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name}", customer_path(@customer)
  end

  def own
    @customers = current_user.customers
    render layout: !request.xhr?
  end

  def search
    @customers = policy_scope(Customer
      .search(params[:search]).excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @customers }
    end
  end

  private

  def set_customer
    @customer = Customer.includes(:surveys, :user).find(params[:id])
  end
end
