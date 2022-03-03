require 'httparty'
require 'json'

Transaction.destroy_all
UserCue.destroy_all
Cue.destroy_all
User.destroy_all
Account.destroy_all

# # cues
rain_cue = Cue.new({title: "Rainy day!", description: "Save money each time it's raining in your city", category: "rain"})
rain_cue.save!
coffee_cue = Cue.new({title: "Coffee break", description: "One break -> one saving", category: "coffee"})
coffee_cue.save!
spenda_cue = Cue.new({title: "Big spenda!", description: "Save money each time you spend more than a certain ammount", category: "spenda"})
spenda_cue.save!
starbucks_cue = Cue.new({title: "Starbucks day!", description: "Save money each time you spend more than a certain ammount", category: "spenda"})
starbucks_cue.save!
>>>>>>> master

# p "4 save cues created 🌱"

# # users
user = User.new({ full_name: "Bibi Ferreira", email: "bibi@email.com", password: "test1234" })
user.save!

# # accounts
checking = Account.new({ name: "Checking", account_type: "checking", iban: "NL43INGB6631699223" })
checking.user = user
checking.save!
savings = Account.new({ name: "Savings", account_type: "savings", iban: "NL86ABNA4643636556" })
savings.user = user
savings.save!
p "Checking and Savings Account created"

# # user cues
# amsterdam_metadata = { location: "Amsterdam, NL" }
# rain_amsterdam_cue = UserCue.new({ user: user, cue: rain_cue, cue_amount: 5, metadata: amsterdam_metadata })
# rain_amsterdam_cue.save

# burger_user_cue = UserCue.new({ user: user, cue: burger_cue, cue_amount: 2 })
# burger_user_cue.save

# spenda_metadata = { limit: 50 }
# spenda_user_cue = UserCue.new({ user: user, cue: spenda_cue, cue_amount: 5, metadata: spenda_metadata })
# spenda_user_cue.save






auth_url = "https://api.mockbank.io/oauth/token"
customers_url = "https://api.mockbank.io/customers"
customer_name = "Bibi"
customer_iban_debit = "NL43INGB6631699223"
customer_iban_debit_name = "Debit"
customer_iban_credit = "NL86ABNA4643636556"
customer_iban_credit_name = "Savings"
transaction_amount = -4


# Generate Access Token
auth_query = { "client_id" => "stephanye", "client_secret" => "secret",
                "grant_type" => "password",
                "username" => "contact@stephanye.io", "password" => "testmock" }
auth_headers = { "content-type" => "application/json" }
mockbank_admin = HTTParty.post(auth_url,
                      query: auth_query,
                      headers: auth_headers)
access_token = mockbank_admin["access_token"]

# Get customer ID
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
customers = HTTParty.get(customers_url,
  headers: auth_headers
)

customers = customers.parsed_response["data"].to_a
customer = ""
customers.each do |object|
  customer = object if object["fullName"] == customer_name
end
customer_id = customer["externalId"]

p "customer id: #{customer_id}"
p "customer url: #{customers_url}"

# Get user account id
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
accounts_url = "#{customers_url}/#{customer_id}/accounts"
customer_accounts = HTTParty.get(accounts_url,
                                 headers: auth_headers
                                )

customer_accounts = customer_accounts.parsed_response["data"].to_a
account = ""
customer_accounts.each do |a|
  account = a if a["iban"] == customer_iban_debit
end
account_id = account["externalId"]

p "account id: #{account_id}"


# Get account transactions
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
transactions_url = "#{customers_url}/#{customer_id}/transactions"
transactions = HTTParty.get(transactions_url,
                            headers: auth_headers
                            )

transactions = transactions.parsed_response["data"].to_a

account_transactions = []
transactions.each do |transaction|
  account_transactions << transaction if transaction["accountId"] == account_id && transaction["creditorName"] == "McDonalds"
end

p account_transactions[0]["amount"]


# Generate a transaction
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
transactions_url = "#{customers_url}/#{customer_id}/transactions"
transaction_body = {
  "accountId": "#{account_id}",
  "amount": -4,
  "bookingDate": "2020-03-03",
  "currency": "EUR",
  "valueDate": "2020-03-03",
  "creditorId": "creditorId",
  "creditorName": "#{customer_iban_credit_name}",
  "creditorAccount": {
    "currency": "EUR",
    "iban": "#{customer_iban_credit}",
  },
  "debtorAccount": {},
  "remittanceInformationUnstructured": "Coffee"
}.to_json

transaction = HTTParty.post(transactions_url,
                            body: transaction_body,
                            headers: auth_headers
                            )
p transaction
