class SubmissionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:index, :new, :create]

  def index
    @submissions = policy_scope(@survey.submissions)
    respond_to do |format|
      format.html {}
      format.js   {}
      format.json { render json: @submissions }
    end
  end

  def new
    @submission = @survey.submissions.build
    @survey.questions.each do |q|
      answer = @submission.answers.build(question: q)
      answer.build_answer_date
      answer.build_answer_image
      answer.build_answer_multiple
      answer.build_answer_open
      answer.build_answer_raiting
      answer.build_choice_answer
    end

    authorize @submission, :new?
  end

  def create
    @submission = @survey.submissions.build(submission_params)
    @submission.user = current_user

    authorize @submission, :create?

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
    @survey = Survey.includes(questions: [:choices, :images, :question_type], submissions: :user).find(params[:survey_id])
  end

  def submission_params
    params.require(:submission).permit(answers_attributes: [:question_id,
      #option_answers_attributes: [:choice_id, :option_id],
      choice_answer_attributes: [:choice_id, :answer_multiple_id],
      answer_date_attributes: :response,
      answer_raiting_attributes: :response,
      answer_open_attributes: :response,
      answer_multiple_attributes: { choice_ids:[] },
      answer_image_attributes: :image_id])
  end
end
