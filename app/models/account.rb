class Account < ApplicationRecord
  has_one :debtor_user, class_name: "User", inverse_of: "debtor_account", foreign_key: "debtor_account_id", dependent: :nullify
  has_one :creditor_user, class_name: "User", inverse_of: "creditor_account", foreign_key: "creditor_account_id", dependent: :nullify
end
