class AddQuestionsCountToSurvey < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :questions_count, :integer, default: 0
  end
end
