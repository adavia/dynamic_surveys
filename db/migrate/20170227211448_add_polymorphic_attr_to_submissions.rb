class AddPolymorphicAttrToSubmissions < ActiveRecord::Migration[5.0]
  def change
    rename_column :submissions, :user_id, :sender_id
    add_column :submissions, :sender_type, :string
  end
end
