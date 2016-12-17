class AddArchivedAtToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :archived_at, :timestamp
  end
end
