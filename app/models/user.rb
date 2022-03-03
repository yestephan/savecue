class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_cues
  has_many :transactions
  has_many :accounts

  belongs_to :creditor_account, class_name: "Account", foreign_key: "creditor_account_id", dependent: :destroy, optional: true
  belongs_to :debtor_account, class_name: "Account", foreign_key: "debtor_account_id", dependent: :destroy, optional: true
end
