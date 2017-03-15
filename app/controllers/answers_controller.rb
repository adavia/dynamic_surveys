class AnswersController < ApplicationController
  before_action :authenticate_user
  before_action :set_question, only: :index
  before_action :check_type_of_request, only: :index

  def index
    respond_to do |format|
      format.html {}
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"answers-#{@question.id}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
      format.js   {}
      format.json { render json: @answers }
    end
  end

  private

  def check_type_of_request
    if request.format == "csv"
      @answers = policy_scope(@question.answers
        .includes(:answer_open, :answer_date, answer_raitings: :raiting,
          submission: :sender)
        .order(created_at: :desc))
    else
      @answers = policy_scope(@question.answers
        .includes(:answer_open, :answer_date, answer_raitings: :raiting,
          submission: :sender)
        .paginate(page: params[:page])
        .order(created_at: :desc))
    end
    filtering_params(params).each do |key, value|
      @answers = @answers.public_send(key, value) if value.present?
    end
  end

  def filtering_params(params)
    params.slice(:created_before, :created_after, :rating_option, :rating_response)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
