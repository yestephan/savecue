class AddDebtorAccountToUserCues < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_cues, :debtor_account, null: false, foreign_key: {to_table: :accounts}
  end
end
