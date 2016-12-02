class CreateQuestionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :question_types do |t|
      t.string :name
      t.string :prefix

      t.timestamps
    end
  end
end
