class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_cues, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :accounts, dependent: :destroy
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

  # Gett Access token
  def get_access_token
    auth_url = "https://api.mockbank.io/oauth/token"
    auth_query = { "client_id" => "stephanye",
                   "client_secret" => "secret",
                   "grant_type" => "password",
                   "username" => "contact@stephanye.io",
                   "password" => "testmock" }
    auth_headers = { "content-type" => "application/json" }
    mockbank_admin = HTTParty.post(auth_url,
                                   query: auth_query,
                                   headers: auth_headers)
    return mockbank_admin["access_token"]
  end

    # Get User's Customer ID from Mockbank
    def get_customer_id(access_token)
      customers_url = "https://api.mockbank.io/customers"
      customer_name = "#{self.first_name} #{self.last_name}"
      auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
      customers = HTTParty.get(customers_url, headers: auth_headers)
      customers = customers.parsed_response["data"].to_a
      customer = ""
      customers.each do |object|
        customer = object if object["fullName"] == customer_name
      end
      return customer["externalId"]
    end

    # Get User's Account ID by using the IBAN provided by the user
    def get_account_id(access_token, customer_id, iban)
      customers_url = "https://api.mockbank.io/customers"
      auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
      accounts_url = "#{customers_url}/#{customer_id}/accounts"
      customer_accounts = HTTParty.get(accounts_url, headers: auth_headers)
      customer_accounts = customer_accounts.parsed_response["data"].to_a
      account = ""
      customer_accounts.each do |element|
        account = element if element["iban"] == iban
      end
      return account["externalId"]
    end


end
