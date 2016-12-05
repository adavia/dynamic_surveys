class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :submission, foreign_key: true
      t.references :question, foreign_key: true
      t.text :answer_open
      t.date :answer_date
      t.string :answer_image
      t.integer :answer_single
      t.integer :answer_raiting
      t.string :type

      t.timestamps
    end
  end
end
