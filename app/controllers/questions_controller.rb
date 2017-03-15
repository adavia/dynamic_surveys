class QuestionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_survey, only: [:new, :create, :edit, :update]
  before_action :set_question, only: [:edit, :update, :destroy]

  def new
    @question = @survey.questions.build
    authorize @question, :create?
  end

  def create
    @question = @survey.questions.build(question_params)

    authorize @question, :create?
    respond_to do |format|
      if @question.save
        format.js   {}
        format.json {
          render json: @question, status: :created, location: @question
        }
      else
        format.js   {}
        format.json {
          render json: @question.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    authorize @question, :edit?
  end

  def update
    authorize @question, :update?

    respond_to do |format|
      if @question.update(question_params)
        format.js   {}
        format.json {
          render json: @question, status: :created, location: @question
        }
      else
        format.js   {}
        format.json {
          render json: @question.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    authorize @question, :destroy?
    @question.destroy
    respond_to do |format|
      format.js {}
    end
  end

  def sort
    params[:question].each_with_index do |id, index|
      Question.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end

  def set_question
    @question = Question.includes([:choices, :images, :raitings]).find(params[:id])
  end

  def question_params
    params.require(:question).permit(:id, :title, :question_type,
      :position, :info_image, :info_image_cache, :remove_info_image, :info_body, :_destroy,
      choices_attributes: [:id, :title, :_destroy],
      raitings_attributes: [:id, :name, :range, :_destroy],
      #options_attributes: [:id, :title, :_destroy],
      images_attributes: [:id, :file, :reference_path, :name, :file_cache, :_destroy])
  end
end
