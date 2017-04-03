class SurveysController < ApplicationController
  before_action :authenticate_user, except: :preview
  before_action :set_customer, only: [:index, :show, :new, :create, :edit,
    :update, :archive]
  before_action :set_survey, only: [:edit, :update, :archive,
    :images, :modal_images, :upload]

  def index
    @surveys = policy_scope(@customer.surveys
      .excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @surveys }
    end

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@customer)
  end

  def show
    @survey = Survey.find(params[:id])
    authorize @survey, :show?
    @submissions = @survey.submissions.includes(:sender)
    @answers = @survey.answers
    @questions = @survey.questions

    @submissions = filter_submissions(@submissions, params)
    @answers = filter_answers(@answers, params)

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        render pdf: "report-#{@survey.id}",
               layout: false,
               dpi: "300",
               encoding: "utf-8"
      end
    end

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@customer)
    add_breadcrumb t("app.survey.breadcrumbs.report"), customer_survey_path(@customer)
  end

  def new
    @survey = @customer.surveys.build
    authorize @survey, :create?

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@customer)
    add_breadcrumb t("app.survey.breadcrumbs.new"), new_customer_survey_path(@customer)
  end

  def create
    @survey = @customer.surveys.build(survey_params)
    authorize @survey, :create?

    respond_to do |format|
      if @survey.save
        format.html { redirect_to [:edit, @customer, @survey],
          flash: { success: t("app.survey.create.alert")}}
        format.js   {}
        format.json {
          render json: @survey, status: :created, location: @survey
        }
      else
        format.html { render 'new' }
        format.js   {}
        format.json {
          render json: @survey.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    authorize @survey, :update?

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@customer)
    add_breadcrumb t("app.survey.breadcrumbs.update"), edit_customer_survey_path(@customer, @survey)
  end

  def update
    authorize @survey, :update?

    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to [:edit, @customer, @survey],
          flash: { success: t("app.survey.update.alert")}}
        format.js   {}
        format.json {
          render json: @survey, status: :created, location: @survey
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @survey.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def archive
    authorize @survey, :archive?
    @survey.archive
    respond_to do |format|
      format.html { redirect_to [@customer, :surveys],
          flash: { success: t("app.survey.archive.alert")}}
      format.js {}
    end
  end

  def search
    @surveys = policy_scope(Survey
      .search(params[:search])
      .excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @surveys }
    end
  end

  def preview
    @survey = Survey.find(params[:id])
    @submissions = @survey.submissions
    render layout: "report"
  end

  def images
    @images = @survey.images.paginate(page: params[:page])
    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@survey.customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@survey.customer)
    add_breadcrumb t("app.survey.images.title"), images_survey_path(@survey)
  end

  def modal_images
    @images = @survey.images.paginate(page: params[:page])
    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.js   {}
    end
  end

  def upload
    authorize @survey, :upload?

    @image = @survey.images.build(file: params[:file], name: params[:name])
    respond_to do |format|
      if @image.save
        format.json { render json: { imagePartial: render_to_string("_image",
          layout: false, locals: { image: @image }) } }
      else
        format.json {
          render plain: "\"#{@image.errors.full_messages.first}\"", status: 422
        }
      end
    end
  end

  private

  def filter_submissions(submissions, params)
    if params[:created_before].present?
      submissions = submissions.created_before(params[:created_before])
    end
    if params[:created_after].present?
      submissions = submissions.created_after(params[:created_after])
    end
    if params[:question_id].present?
      submissions = submissions.question_id(params[:question_id])
    end
    if params[:choice_id].present?
      submissions = submissions.choice_id(params[:choice_id])
    end
    if params[:choice_multiple_ids].present?
      submissions = submissions.choice_multiple_ids(params[:choice_multiple_ids])
    end
    if params[:image_id].present?
      submissions = submissions.image_id(params[:image_id])
    end
    if params[:rating_id].present? && params[:rate].present?
      submissions = submissions.rate(params[:rating_id], params[:rate])
    end
    submissions
  end

  def filter_answers(answers, params)
    if params[:created_before].present?
      answers = answers.created_before(params[:created_before])
      answers = Answer.collect_submissions(answers)
    end
    if params[:created_after].present?
      answers = answers.created_after(params[:created_after])
      answers = Answer.collect_submissions(answers)
    end
    if params[:question_id].present?
      answers = answers.question_id(params[:question_id])
      answers = Answer.collect_submissions(answers)
    end
    if params[:choice_id].present?
      answers = answers.choice_id(params[:choice_id])
      answers = Answer.collect_submissions(answers)
    end
    if params[:choice_multiple_ids].present?
      answers = answers.choice_multiple_ids(params[:choice_multiple_ids])
      answers = Answer.collect_submissions(answers)
    end
    if params[:image_id].present?
      answers = answers.image_id(params[:image_id])
      answers = Answer.collect_submissions(answers)
    end
    if params[:rating_id].present? && params[:rate].present?
      answers = answers.rate(params[:rating_id], params[:rate])
      answers = Answer.collect_submissions(answers)
    end
    answers
  end

  def set_survey
    @survey = Survey.includes(:images, questions: [:choices, :images, :raitings, :answers]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def survey_params
    params.require(:survey).permit(:name, :description, :avatar, :avatar_cache,
      :remove_avatar)
  end
end
