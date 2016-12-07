class API::SurveysController < API::ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: [:index]
  before_action :set_survey, only: [:show]

  def index
    @surveys = @customer.surveys
    render json: @surveys, include: [:id, :name, :description,
      :question_counter, :created_at, :customer]
  end

  def show
    render json: @survey, include: [:id, :name, :description,
      :created_at, :customer, :questions]
  end

  private

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
