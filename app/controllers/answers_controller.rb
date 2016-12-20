class AnswersController < ApplicationController
  before_action :authenticate_user
  before_action :set_question, only: :index

  def index
    @answers = policy_scope(@question.answers)
    respond_to do |format|
      format.html {}
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"answers-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
      format.xls  {}
      format.js   {}
      format.json { render json: @answers }
    end
  end

  private

  def set_question
    @question = Question.includes(answers: [:answer_open, :answer_date,
      submission: :user]).find(params[:question_id])
  end
end
