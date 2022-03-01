class AddFieldToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :bank_account, :string
    add_column :users, :address, :string
  end
end
