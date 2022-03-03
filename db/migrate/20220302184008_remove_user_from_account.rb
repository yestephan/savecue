class RemoveUserFromAccount < ActiveRecord::Migration[6.1]
  def change
    remove_reference :accounts, :user, null: false, foreign_key: true
  end
end
