class RemoveFieldsFromAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :answer_open
    remove_column :answers, :answer_date
    remove_column :answers, :answer_image
    remove_column :answers, :answer_single
    remove_column :answers, :answer_raiting
  end
end
