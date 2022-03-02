class AddAccountsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :creditor_account, null: false, foreign_key: {to_table: :accounts}
    add_reference :users, :debtor_account, null: false, foreign_key: {to_table: :accounts}
  end
end
