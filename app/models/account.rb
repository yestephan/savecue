class Account < ApplicationRecord
  belongs_to :user

  has_many :creditor_user_cues, class_name: "UserCue", inverse_of: :creditor_account
  has_many :debtor_user_cues, class_name: "UserCue", inverse_of: :debtor_account
end
