class AnswersController < ApplicationController
  before_action :authenticate_user
  before_action :set_question, only: :index

  def index
    if request.format == "csv"
      @answers = policy_scope(@question.answers
      .includes([:answer_open, :answer_date], submission: :user)
      .order(created_at: :desc))
    else
      @answers = policy_scope(@question.answers
      .includes([:answer_open, :answer_date], submission: :user)
      .paginate(page: params[:page])
      .order(created_at: :desc))
    end
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

  def set_question
    @question = Question.find(params[:question_id])
  end
end
