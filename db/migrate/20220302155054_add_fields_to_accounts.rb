class AddFieldsToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :owner_name, :string
    add_column :accounts, :account_id, :string
  end
end
