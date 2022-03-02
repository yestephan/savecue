class RemoveBankAccountFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :bank_account, :string
  end
end
