class SurveysController < ApplicationController
  before_action :authenticate_user, except: :preview
  before_action :set_customer, only: [:index, :show, :new, :create, :edit,
    :update, :archive]
  before_action :set_survey, only: [:show, :edit, :update, :archive, :preview,
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
    authorize @survey, :show?
    if request.format == "csv"
      @submissions = policy_scope(@survey.submissions
        .includes(:sender))
    else
      @submissions = policy_scope(@survey.submissions
        .includes(:sender))
    end

    filtering_params(params).each do |key, value|
      @submissions = @submissions.public_send(key, value) if value.present?
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

  def filtering_params(params)
    params.slice(:created_before, :created_after, :question_id,
      :choice_id, :image_id, :choice_multiple_ids)
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
