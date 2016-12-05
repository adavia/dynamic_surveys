class CreateOptionAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :option_answers do |t|
      t.references :answer, foreign_key: true
      t.references :option, foreign_key: true
      t.references :choice, foreign_key: true

      t.timestamps
    end
  end
end
