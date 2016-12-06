class CreateChoiceAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :choice_answers do |t|
      t.references :choice, foreign_key: true
      t.references :answer, foreign_key: true
      t.references :answer_multiple, foreign_key: true

      t.timestamps
    end
  end
end
