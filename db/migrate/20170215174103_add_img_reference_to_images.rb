class AddImgReferenceToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :reference_path, :string
    add_column :images, :name, :string
  end
end
