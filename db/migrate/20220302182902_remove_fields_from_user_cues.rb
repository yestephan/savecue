class RemoveFieldsFromUserCues < ActiveRecord::Migration[6.1]
  def change
    remove_reference :user_cues, :debtor_account, null: false, foreign_key: {to_table: :accounts}
    remove_reference :user_cues, :creditor_account, null: false, foreign_key: {to_table: :accounts}
  end
end
