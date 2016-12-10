class AddSurveysCountToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :surveys_count, :integer, default: 0
  end
end
