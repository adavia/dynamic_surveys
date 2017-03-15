class AddCredentialFieldsToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :username, :string
    add_column :customers, :password_digest, :string
    add_column :customers, :api_key, :string
  end
end
