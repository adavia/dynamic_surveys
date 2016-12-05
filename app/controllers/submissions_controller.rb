class SubmissionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:new, :create]

  def new
    @submission = @survey.submissions.build
    @survey.questions.each do |q|
      @submission.answers.build(question: q)
    end
  end

  def create
    @submission = @survey.submissions.build(submission_params)
    @submission.user = current_user

    respond_to do |format|
      if @submission.save
        format.html { redirect_to [@survey.customer, :surveys],
          flash: { success: "The survey has been submitted successfully."}}
        format.js   {}
        format.json {
          render json: @submission, status: :created, location: @submission
        }
      else
        format.html { render 'new' }
        format.js   {}
        format.json {
          render json: @submission.errors, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def submission_params
    params.require(:submission).permit(:options, answers_attributes: [:question_id, :answer_open,
      :answer_date, :answer_image, :answer_single, :answer_raiting, choice_ids:[],
      option_answers_attributes: [:choice_id, :option_id]])
  end
end
