class Account < ApplicationRecord
  TYPE_SAVINGS = "savings"
  TYPE_CHECKING = "checking"

  belongs_to :user

  validates :account_type, inclusion: { in: [Account::TYPE_SAVINGS, Account::TYPE_CHECKING], message: "%{value} is not a valid account type" }
end
