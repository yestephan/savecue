class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :account_type
      t.string :iban

      t.timestamps
    end
  end
end
