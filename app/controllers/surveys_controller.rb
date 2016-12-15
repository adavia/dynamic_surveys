class SurveysController < ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: [:index, :show]
  before_action :set_survey, only: :show

  def index
    @surveys = @customer.surveys
    respond_to do |format|
      format.html {}
      format.json { render json: @surveys }
    end
  end

  def show
    authorize @survey, :show?
    respond_to do |format|
      format.html {}
      format.json { render json: @survey }
    end
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :question_type, :answers]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def survey_params
    params.require(:survey).permit(:name, :description, :avatar, :avatar_cache,
      questions_attributes: [:id, :title, :question_type_id, :_destroy,
      choices_attributes: [:id, :title, :_destroy],
      #options_attributes: [:id, :title, :_destroy],
      images_attributes: [:id, :file, :file_cache, :_destroy]])
  end
end
