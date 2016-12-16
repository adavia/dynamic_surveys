class Admin::SurveysController < Admin::ApplicationController
  before_action :set_customer, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_survey, only: [:edit, :update, :destroy]

  def new
    @survey = Survey.new
  end

  def create
    @survey = @customer.surveys.build(survey_params)

    respond_to do |format|
      if @survey.save
        format.html { redirect_to [@customer, @survey],
          flash: { success: "The survey has been created successfully."}}
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
  end

  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to [@customer, @survey],
          flash: { success: "The survey has been updated successfully."}}
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

  def destroy
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to [@customer, :surveys],
          flash: { success: "The survey has been deleted successfully."}}
      format.js {}
    end
  end

  private

  def set_survey
    @survey = Survey.includes(questions: [:choices, :images, :question_type, :answers]).find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:customer_id])
  end

  def survey_params
    params.require(:survey).permit(:name, :description, :avatar, :avatar_cache,
      questions_attributes: [:id, :title, :question_type_id, :_destroy,
      choices_attributes: [:id, :title, :_destroy],
      #options_attributes: [:id, :title, :_destroy],
      images_attributes: [:id, :file, :file_cache, :_destroy]])
  end
end