class CreateAnswerOpens < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_opens do |t|
      t.text :response
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
