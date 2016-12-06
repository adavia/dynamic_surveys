class CreateAnswerImages < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_images do |t|
      t.references :image, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
