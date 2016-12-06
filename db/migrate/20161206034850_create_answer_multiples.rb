class CreateAnswerMultiples < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_multiples do |t|
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
