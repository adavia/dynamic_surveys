class API::SurveysController < API::ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: [:index, :show]
  before_action :set_survey, only: :show

  def index
    render json: {
      avatar: @customer.avatar,
      surveys: @customer.surveys.as_json(except: [:questions, :customer_id,
        :updated_at, :avatar, :archived_at])
    }
  end

  def show
    render json: {
      avatar: @customer.avatar,
      survey: @survey.as_json(include: { questions: {
        include: [:choices, :images, :raitings]}}, except: [:customer_id, :updated_at,
          :questions_count, :archived_at])
    }
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :raitings]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
end
