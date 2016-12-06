class RemoveTypeFromAnswers < ActiveRecord::Migration[5.0]
  def change
    remove_column :answers, :type
  end
end
