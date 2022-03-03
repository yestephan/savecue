class AddAccountsToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :accounts, :user, foreign_key: true
  end
end
