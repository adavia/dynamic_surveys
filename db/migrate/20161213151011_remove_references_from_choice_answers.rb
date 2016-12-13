class RemoveReferencesFromChoiceAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :choice_answers, :choice, index: true
  end
end
