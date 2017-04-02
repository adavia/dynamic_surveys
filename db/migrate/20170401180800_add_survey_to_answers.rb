class AddSurveyToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_reference :answers, :survey, foreign_key: true
    remove_foreign_key :images, column: :imageable_id
  end
end
