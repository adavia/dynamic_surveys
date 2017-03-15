class AddRaitingIdToAnswerRaitings < ActiveRecord::Migration[5.0]
  def change
    add_reference :answer_raitings, :raiting, foreign_key: true
  end
end
