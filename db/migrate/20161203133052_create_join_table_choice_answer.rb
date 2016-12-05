class CreateJoinTableChoiceAnswer < ActiveRecord::Migration[5.0]
  def change
    create_join_table :choices, :answers do |t|
      # t.index [:choice_id, :answer_id]
      # t.index [:answer_id, :choice_id]
    end
  end
end
