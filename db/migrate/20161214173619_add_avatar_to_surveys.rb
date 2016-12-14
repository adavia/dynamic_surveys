class AddAvatarToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :avatar, :string
  end
end
