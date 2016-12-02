class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :description
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
