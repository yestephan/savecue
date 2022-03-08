class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_cues, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :cues, through: :user_cues
  # has_one_attached :photo

  def avatar_url
    unless self.picture.nil?
      image_path = Cloudinary::Utils.cloudinary_url(self.picture, width: 56, height: 56, crop: :fill, gravity: :face, default_image: "avatar_null.png")
      image_path.sub('/production', '')
    else
      "avatar_null.png"
    end
  end

  def checking_account
    self.accounts.find_by(account_type: Account::TYPE_CHECKING)
  end

  def savings_account
    self.accounts.find_by(account_type: Account::TYPE_SAVINGS)
  end
end
