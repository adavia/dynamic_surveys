class SurveysController < ApplicationController
  before_action :authenticate_user
  before_action :set_customer, only: [:index, :show, :new, :create, :edit, :update, :archive]
  before_action :set_survey, only: [:show, :edit, :update, :archive]

  def index
    @surveys = policy_scope(@customer.surveys.excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @surveys }
    end
  end

  def show
    authorize @survey, :show?
    respond_to do |format|
      format.html {}
      format.pdf do
        pdf = SurveyPdf.new(@survey, view_context)
        send_data pdf.render,
          filename: "report_#{@survey.created_at.strftime('%m/%d/%Y')}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
      format.json { render json: @survey }
    end
  end

  def new
    @survey = @customer.surveys.build
    authorize @survey, :create?
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
      .search(params[:search]).excluding_archived
      .paginate(page: params[:page]))
    respond_to do |format|
      format.html {}
      format.json { render json: @surveys }
    end
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :answers]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def survey_params
    params.require(:survey).permit(:name, :description, :avatar, :avatar_cache,
      :remove_avatar, questions_attributes: [:id, :title, :question_type,
      :position, :info_image, :info_image_cache, :remove_info_image, :info_body, :_destroy,
      choices_attributes: [:id, :title, :_destroy],
      #options_attributes: [:id, :title, :_destroy],
      images_attributes: [:id, :file, :file_cache, :_destroy]])
  end
end
