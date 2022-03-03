class RemoveOwnerNameFromAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :accounts, :owner_name, :string
  end
end
