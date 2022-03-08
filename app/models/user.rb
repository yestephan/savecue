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

  # Get Access token
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

    # Get User's Customer ID from M nockbank
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

    # Get transactions from specified account
    def get_transactions(access_token, customer_id, account_id, condition)
      yesterday = (Time.now - 1.day).strftime("%Y-%m-%d")
      customers_url = "https://api.mockbank.io/customers"
      auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
      transactions_url = "#{customers_url}/#{customer_id}/transactions"
      transactions = HTTParty.get(transactions_url, headers: auth_headers).parsed_response["data"].to_a.reverse
      account_transactions = []
      transactions.each do |transaction|
        # Could be changed into a proc
        unless transaction["creditorName"].nil? || transaction.nil?
          if transaction["accountId"] == account_id && transaction["creditorName"].downcase == condition && transaction["bookingDate"] == yesterday
            account_transactions << transaction
          end
        end
      end
      return account_transactions
    end

    # Trigger transaction
    def create_saving(access_token, customer_id, account_id, name, savings_iban, checking_iban, cue_amount, cue_category)
      customers_url = "https://api.mockbank.io/customers"
      booking_date = Time.now.strftime("%Y-%m-%d")
      auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
      transactions_url = "#{customers_url}/#{customer_id}/transactions"
      transaction_body = {
        "accountId": "#{account_id}",
        "amount": "-#{cue_amount}",
        "bookingDate": "#{booking_date}",
        "currency": "EUR",
        "valueDate": "#{booking_date}",
        "creditorId": "creditorId",
        "creditorName": "#{name}",
        "creditorAccount": {
          "currency": "EUR",
          "iban": "#{savings_iban}",
        },
        "debtorName": "#{name}",
        "debtorAccount": {
          "iban": "#{checking_iban}",
        },
        "remittanceInformationStructured": "savecue",
        "remittanceInformationUnstructured": "#{cue_category}"
      }.to_json
      HTTParty.post(transactions_url, body: transaction_body, headers: auth_headers)
    end
end
