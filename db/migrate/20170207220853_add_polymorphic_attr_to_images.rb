class AddPolymorphicAttrToImages < ActiveRecord::Migration[5.0]
  def change
    rename_column :images, :question_id, :imageable_id
    add_column :images, :imageable_type, :string
  end
end
