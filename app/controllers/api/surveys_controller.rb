class API::SurveysController < API::ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: :index
  before_action :set_survey, only: :show

  def index
    @surveys = policy_scope(@customer.surveys)
    render json: {
      avatar: current_user.image,
      surveys: @surveys.as_json(except: [:questions, :customer_id])
    }
  end

  def show
    authorize @survey, :show?
    render json: {
      avatar: current_user.image,
      survey: @survey.as_json(include: { questions: {
        include: [:question_type, :choices, :images ]}}, except: :customer_id)
    }
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :question_type]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
