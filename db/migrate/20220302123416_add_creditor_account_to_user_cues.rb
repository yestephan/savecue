class AddCreditorAccountToUserCues < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_cues, :creditor_account, null: false, foreign_key: {to_table: :accounts}
  end
end
