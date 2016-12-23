class CustomersController < ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: :show

  def index
    @customers = policy_scope(Customer.excluding_archived.paginate(page: params[:page]))
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
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :description)
  end

  def set_customer
    @customer = Customer.includes(:surveys, :user).find(params[:id])
  end
end
