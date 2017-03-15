class AddConditionToAlertFilters < ActiveRecord::Migration[5.0]
  def change
    add_column :alert_filters, :condition, :string
  end
end
