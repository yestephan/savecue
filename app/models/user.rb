class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_cues, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :accounts, dependent: :destroy

  belongs_to :creditor_account, class_name: "Account", foreign_key: "creditor_account_id", dependent: :destroy, optional: true
  belongs_to :debtor_account, class_name: "Account", foreign_key: "debtor_account_id", dependent: :destroy, optional: true
end
