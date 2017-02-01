class AddCompleteToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :complete, :boolean, default: false
  end
end
