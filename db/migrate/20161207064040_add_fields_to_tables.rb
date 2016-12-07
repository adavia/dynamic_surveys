class AddFieldsToTables < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :question_type, index: true
    add_foreign_key :questions, :question_types
    add_reference :choice_answers, :answer_multiple, index: true
    add_foreign_key :choice_answers, :answer_multiples
  end
end
