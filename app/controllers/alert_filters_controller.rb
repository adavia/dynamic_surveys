class AlertFiltersController < ApplicationController
  before_action :authenticate_user
  before_action :set_alert, only: [:new, :create, :edit, :update]
  before_action :set_alert_filter, only: [:edit, :update, :destroy]

  def new
    @alert_filter = @alert.alert_filters.build
    authorize @alert_filter, :create?
  end

  def create
    @alert_filter = @alert.alert_filters.build(alert_filter_params)

    authorize @alert_filter, :create?
    respond_to do |format|
      if @alert_filter.save
        format.js   {}
        format.json {
          render json: @alert_filter, status: :created, location: @alert_filter
        }
      else
        format.js   {}
        format.json {
          render json: @alert_filter.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    authorize @alert_filter, :edit?
  end

  def update
    authorize @alert_filter, :update?

    respond_to do |format|
      if @alert_filter.update(alert_filter_params)
        format.js   {}
        format.json {
          render json: @alert_filter, status: :created, location: @alert_filter
        }
      else
        format.js   {}
        format.json {
          render json: @alert_filter.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    authorize @alert_filter, :destroy?
    @alert_filter.destroy
    respond_to do |format|
      format.js {}
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
      elsif params[:question_type] == "rating"
        @ratings = Raiting.where("question_id = ?", params[:question_id])
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_alert
    @alert = Alert.find(params[:alert_id])
  end

  def set_alert_filter
    @alert_filter = AlertFilter.find(params[:id])
  end

  def alert_filter_params
    params.require(:alert_filter).permit(:id, :question_id, :raiting_id,
        { answer:[] }, :alert_id)
  end
end
