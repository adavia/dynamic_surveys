class CreateAnswerRaitings < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_raitings do |t|
      t.integer :response
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
