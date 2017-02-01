class CreateSubmissionViews < ActiveRecord::Migration[5.0]
  def change
    create_table :submission_views do |t|
      t.references :survey, foreign_key: true
      t.references :user, foreign_key: true
      t.string :ip_address

      t.timestamps
    end
  end
end
