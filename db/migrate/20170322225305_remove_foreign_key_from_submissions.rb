class RemoveForeignKeyFromSubmissions < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :submissions, column: :sender_id
  end
end
