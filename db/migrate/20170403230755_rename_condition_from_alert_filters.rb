class RenameConditionFromAlertFilters < ActiveRecord::Migration[5.0]
  def change
    remove_column :alert_filters, :condition, :string
    remove_column :alert_filters, :title, :string
    add_reference :alert_filters, :raiting, foreign_key: true
  end
end
