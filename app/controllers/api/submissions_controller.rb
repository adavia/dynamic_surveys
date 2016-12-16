class API::SubmissionsController < API::ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: :create

  def create
    @submission = @survey.submissions.build(submission_params)
    authorize @submission, :create?
    if @submission.save
      render json: @submission, status: 201
    else
      render json: @submission.errors, status: :unprocessable_entity
    end
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :question_type]).find(params[:survey_id])
  end

  def submission_params
    params.require(:submission).permit(:user_id,
      answers_attributes: [:question_id, :submission_id,
      #option_answers_attributes: [:choice_id, :option_id],
      choice_answer_attributes: [:choice_id, :answer_multiple_id],
      answer_date_attributes: :response,
      answer_raiting_attributes: :response,
      answer_open_attributes: :response,
      answer_multiple_attributes: { choice_ids:[] },
      answer_image_attributes: :image_id])
  end
end
