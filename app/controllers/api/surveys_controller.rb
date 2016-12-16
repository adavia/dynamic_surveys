class API::SurveysController < API::ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: [:index]
  before_action :set_survey, only: [:show]

  def index
    @surveys = policy_scope(@customer.surveys)
    render json: @surveys, include: [:id, :name, :description,
      :created_at, :customer]
  end

  def show
    authorize @survey, :show?
    render json: @survey, include: [:id, :name, :description,
      :created_at, :customer, "questions.question_type",
      "questions.choices", "questions.images"]
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :question_type]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
