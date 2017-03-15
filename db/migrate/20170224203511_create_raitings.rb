class CreateRaitings < ActiveRecord::Migration[5.0]
  def change
    create_table :raitings do |t|
      t.string :name
      t.integer :range
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
