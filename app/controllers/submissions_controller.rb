class SubmissionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:index, :new, :create]
  before_action :set_submission, only: :show
  before_action :check_type_of_request, only: :index
  before_action :log_view, only: :new

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
    render layout: !request.xhr?
  end

  def new
    @submission = @survey.submissions.build
    @survey.questions.each do |q|
      answer = @submission.answers.build(question: q)
      answer.build_answer_date
      answer.build_answer_image
      answer.build_answer_multiple
      answer.build_answer_open
      answer.build_choice_answer
      q.raitings.count.times { answer.answer_raitings.build }
    end

    authorize @submission, :new?
    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@survey.customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@survey.customer)
    add_breadcrumb t("app.submission.breadcrumbs.new"), new_survey_submission_path(@survey)
  end

  def create
    @submission = @survey.submissions.build(submission_params)
    @submission.sender = current_user

    authorize @submission, :create?

    respond_to do |format|
      if @submission.save

        notifier(@survey, @submission)

        format.html { redirect_to [@survey.customer, :surveys],
          flash: { success: t("app.submission.create.alert")}}
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

  def update_choices
    if params[:question_id].present?
      if params[:question_type] == "image"
        @images = Image.where("imageable_id = ?", params[:question_id])
      elsif ["single", "list"].include? params[:question_type]
        @choices = Choice.where("question_id = ?", params[:question_id])
      elsif params[:question_type] == "multiple"
        @multiple = Choice.where("question_id = ?", params[:question_id])
      end
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def log_view
    @survey.submission_views.where(ip_address: request.remote_ip, user_id: current_user.id).first_or_create
  end

  def notifier(survey, submission)
    if survey.alerts.any? && submission.answers.any?
      survey.alerts.each do |alert|
        responses = filter_notifications(submission, alert)
        if responses.any?
          Rails.logger.debug responses[0]
          #SubmissionNotifierMailer.notifier(responses[0], alert).deliver
        end
      end
    end
  end

  def filter_notifications(submission, alert)
    submission.answers.select do |a|
      case a.question.question_type
      when "image"
        a.question == alert.alert_filter.question && a.answer_image.image_id == alert.alert_filter.answer.to_i
      when "single"
        a.question == alert.alert_filter.question && a.choice_answer.choice_id == alert.alert_filter.answer.to_i
      when "list"
        a.question == alert.alert_filter.question && a.choice_answer.choice_id == alert.alert_filter.answer.to_i
      when "multiple"
        a.question == alert.alert_filter.question && !(to_array(alert) & a.answer_multiple.choices.map(&:id)).empty?
      when "rating"
        results = verify_condition(alert, a)
        a.question == alert.alert_filter.question && results.any?
      else
        a.question == alert.alert_filter.question
      end
    end
  end

  def to_array(alert)
    alert.alert_filter.answer.split(",").map(&:to_i)
  end

  def verify_condition(alert, a)
    case alert.alert_filter.condition
    when "greater"
      a.answer_raitings.map(&:response).select do |r|
        r > alert.alert_filter.answer.to_i
      end
    when "equal"
      a.answer_raitings.map(&:response).select do |r|
        r == alert.alert_filter.answer.to_i
      end
    else
      a.answer_raitings.map(&:response).select do |r|
        r < alert.alert_filter.answer.to_i
      end
    end
  end

  def check_type_of_request
    if request.format == "csv"
      @submissions = policy_scope(@survey.submissions
        .includes(:sender)
        .order(created_at: :desc))
    else
      @submissions = policy_scope(@survey.submissions
        .includes(:sender)
        .paginate(page: params[:page])
        .order(created_at: :desc))

      filtering_params(params).each do |key, value|
        @submissions = @submissions.public_send(key, value) if value.present?
      end
    end
  end

  def filtering_params(params)
    params.slice(:created_before, :created_after, :question_id,
      :choice_id, :image_id, :choice_multiple_ids)
  end

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :raitings]).find(params[:survey_id])
  end

  def set_submission
    @submission = Submission.includes(survey: :customer, answers: [:answer_open, :answer_date,
      { answer_raitings: :raiting }, :answer_multiple, :answer_image,
      :choice_answer, :question]).find(params[:id])
  end

  def submission_params
    params.require(:submission).permit(answers_attributes: [:question_id,
      #option_answers_attributes: [:choice_id, :option_id],
      choice_answer_attributes: [:choice_id, :answer_multiple_id],
      answer_date_attributes: :response,
      answer_raitings_attributes: [:raiting_id, :response],
      answer_open_attributes: :response,
      answer_multiple_attributes: { choice_ids:[] },
      answer_image_attributes: :image_id])
  end
end
