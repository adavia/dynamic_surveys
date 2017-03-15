class CreateAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :alerts do |t|
      t.string :from
      t.string :subject
      t.string :body
      t.string :to
      t.references :survey, foreign_key: true

      t.timestamps
    end
  end
end
