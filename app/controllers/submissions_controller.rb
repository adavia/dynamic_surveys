class SubmissionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:index, :new, :create]
  before_action :set_submission, only: :show
  before_action :check_type_of_request, only: :index

  def index
    respond_to do |format|
      format.html {}
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"submissions-#{@survey.id}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
      format.js   {}
      format.json { render json: @submissions }
    end
  end

  def show
    authorize @submission, :show?
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

        rating_notifier(@submission)

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

  def rating_notifier(submission)
    if submission.answers.rated_answers.any?
      SubmissionNotifierMailer.rating_notifier(submission).deliver_later
    end
  end

  def check_type_of_request
    if request.format == "csv"
      if params[:from].present? && params[:to].present?
        @submissions = policy_scope(@survey.submissions.includes(:user)
          .search(params[:from], params[:to])
          .order(created_at: :desc))
      else
        @submissions = policy_scope(@survey.submissions.includes(:user)
          .order(created_at: :desc))
      end
    else
      if params[:from].present? && params[:to].present?
        @submissions = policy_scope(@survey.submissions.includes(:user)
          .search(params[:from], params[:to])
          .paginate(page: params[:page])
          .order(created_at: :desc))
      else
        @submissions = policy_scope(@survey.submissions.includes(:user)
          .paginate(page: params[:page])
          .order(created_at: :desc))
      end
    end
  end

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images]).find(params[:survey_id])
  end

  def set_submission
    @submission = Submission.includes(survey: :customer, answers: [:answer_open, :answer_date,
      :answer_raiting, :answer_multiple, :answer_image,
      :choice_answer, :question]).find(params[:id])
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
