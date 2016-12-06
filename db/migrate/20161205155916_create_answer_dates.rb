class CreateAnswerDates < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_dates do |t|
      t.date :response
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
