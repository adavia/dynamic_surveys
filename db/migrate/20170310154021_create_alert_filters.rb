class CreateAlertFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :alert_filters do |t|
      t.string :title
      t.references :question, foreign_key: true
      t.string :answer
      t.references :alert, foreign_key: true

      t.timestamps
    end
  end
end
