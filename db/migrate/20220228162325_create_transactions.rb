class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.references :user, null: false, foreign_key: true
      t.references :user_cue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
