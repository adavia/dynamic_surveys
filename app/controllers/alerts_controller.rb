class AlertsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_alert, only: [:edit, :update, :destroy]

  def index
    @alerts = @survey.alerts
      .paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.json { render json: @alerts }
    end

    add_breadcrumb t("app.customer.breadcrumbs.list"), :customers_path
    add_breadcrumb "#{@survey.customer.name} - #{t("app.survey.breadcrumbs.list").downcase}", customer_surveys_path(@survey.customer)
    add_breadcrumb t("app.survey.breadcrumbs.notifications"), survey_alerts_path(@survey)
  end

  def new
    @alert = @survey.alerts.build
    authorize @alert, :create?

    add_breadcrumb t("app.survey.breadcrumbs.notifications"), survey_alerts_path(@survey)
    add_breadcrumb t("app.survey.notifications.breadcrumbs.new"), new_survey_alert_path(@survey)
  end

  def create
    @alert = @survey.alerts.build(alert_params)

    authorize @alert, :create?
    respond_to do |format|
      if @alert.save
        format.html { redirect_to [:edit, @survey, @alert],
          flash: { success: t("app.survey.notifications.create.alert")}}
        format.js   {}
        format.json {
          render json: @alert, status: :created, location: @alert
        }
      else
        format.html { render 'new' }
        format.js   {}
        format.json {
          render json: @alert.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    authorize @alert, :edit?

    add_breadcrumb t("app.survey.breadcrumbs.notifications"), survey_alerts_path(@survey)
    add_breadcrumb t("app.survey.notifications.breadcrumbs.edit"), edit_survey_alert_path(@survey, @alert)
  end

  def update
    authorize @alert, :update?

    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to [@survey, :alerts],
          flash: { success: t("app.survey.notifications.update.alert")}}
        format.js   {}
        format.json {
          render json: @alert, status: :created, location: @alert
        }
      else
        format.html { render 'edit' }
        format.js   {}
        format.json {
          render json: @alert.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    authorize @alert, :destroy?
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to [@survey, :alerts],
          flash: { success: t("app.survey.notifications.destroy.alert")}}
      format.js {}
    end
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def set_alert
    @alert = Alert.includes(alert_filters: [:question, :raiting]).find(params[:id])
  end

  def alert_params
    params.require(:alert).permit(:from, :subject, :body, :to)
  end
end
