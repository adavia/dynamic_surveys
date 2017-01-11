class AddInfoImageAndInfoBodyToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :info_image, :string
    add_column :questions, :info_body, :text
  end
end
