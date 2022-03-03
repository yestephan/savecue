class RemoveAccountIdFromAccounts < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :debtor_account_id
    remove_column :users, :creditor_account_id
  end
end
