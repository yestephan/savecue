class UserCue < ApplicationRecord
  belongs_to :user
  belongs_to :cue

  belongs_to :creditor_account, class_name: "Account", foreign_key: "creditor_account_id"
  belongs_to :debtor_account, class_name: "Account", foreign_key: "debtor_account_id"
end
