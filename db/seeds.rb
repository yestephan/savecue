require 'httparty'
require 'json'

UserCue.destroy_all
Cue.destroy_all
User.destroy_all
Account.destroy_all

# Cues
rain = Cue.new({ title: "Rainy day!",
                 description: "It's raining, and you'r saving 😉",
                 category: "rain",
                 color: "bg-barge",
                 emoji: "🌧" })
rain.save!
spenda = Cue.new({ title: "Big spenda!",
                   description: "You spend money ➡️ You save money!",
                   category: "money",
                   color: "bg-green",
                   emoji: "💸" })
spenda.save!
starbucks = Cue.new({ title: "Starbucks",
                      description: "Starbucks coffee is great, saving is better.",
                      category: "coffee",
                      color: "bg-coffee",
                      emoji: "☕️" })
starbucks.save!
burger = Cue.new({ title: "Burger day!",
                   description: "Super size your savings. One burger = 💰",
                   category: "burger",
                   color: "bg-jade",
                   emoji: "🍔" })
burger.save!
Cue.all.each do |cue|
  puts "#{cue.title} cue created 🌱"
end

# Users and Accounts created
bibi = User.new({ first_name: "Bibi", last_name: "Ferreira", email: "bibi@email.com", password: "test1234" })
bibi.save!
checking = Account.new({ name: "Checking", account_type: Account::TYPE_CHECKING, iban: "NL43INGB6631699223", user: bibi })
checking.save!
savings = Account.new({ name: "Savings", account_type: Account::TYPE_SAVINGS, iban: "NL86ABNA4643636556", user: bibi })
savings.save!

james = User.new({ first_name: "James", last_name: "Maddison", email: "james@email.com", password: "test1234" })
james.save!
checking = Account.new({ name: "Checking", account_type: Account::TYPE_CHECKING, iban: "NL69481516230000001507", user: james })
checking.save!
savings = Account.new({ name: "Savings", account_type: Account::TYPE_SAVINGS, iban: "NL80481516230000001503", user: james })
savings.save!

p "Checking and Savings Account created for #{bibi.first_name} #{bibi.last_name}"
p "Checking and Savings Account created for  #{james.first_name} #{james.last_name}"

# User cues
User.all.each do |user|
  rand_nr = rand(1..5)
  use_cue = UserCue.new({ user: user, cue: burger, cue_amount: rand_nr })
  use_cue.save!
  rand_nr = rand(1..5)
  use_cue = UserCue.new({ user: user, cue: starbucks, cue_amount: rand_nr })
  use_cue.save!
  puts user.first_name
  puts user.user_cues.each{ |user_cue| puts user_cue.cue.title }
end
<<<<<<< HEAD

auth_url = "https://api.mockbank.io/oauth/token"
customers_url = "https://api.mockbank.io/customers"
customer_name = "Bibi Ferreira"
customer_iban_debit = "NL43INGB6631699223"
customer_iban_debit_name = "Debit"
customer_iban_credit = "NL86ABNA4643636556"
customer_iban_credit_name = "Savings"

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

# Get account transactions - Filtered
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
transactions_url = "#{customers_url}/#{customer_id}/transactions"
transactions = HTTParty.get(transactions_url,
                            headers: auth_headers)
transactions = transactions.parsed_response["data"].to_a
account_transactions = []
transactions.each do |transaction|
 if transaction["accountId"] == account_id
  if transaction["creditorName"]
    account_transactions << transaction if transaction["creditorName"].downcase == "starbucks"
  end
 end
end

# This is the date condition
date_now = Time.now.strftime("%Y-%m-%d")
# This is the filter condition that you can use for the work that you are using.
filter = {"bookingDate" => "#{date_now}"}
# binding.pry
results = account_transactions.select do |elem|
  filter.all? do |key, value|
    elem[key] == value
  end
end
p results.count

# # Generate a transaction
# auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
# transactions_url = "#{customers_url}/#{customer_id}/transactions"
# transaction_body = {
#   "accountId": "#{account_id}",
#   "amount": -4,
#   "bookingDate": "2020-03-03",
#   "currency": "EUR",
#   "valueDate": "2020-03-03",
#   "creditorId": "creditorId",
#   "creditorName": "#{customer_iban_credit_name}",
#   "creditorAccount": {
#     "currency": "EUR",
#     "iban": "#{customer_iban_credit}",
#   },
#   "debtorAccount": {},
#   "remittanceInformationUnstructured": "Coffee"
# }.to_json

# transaction = HTTParty.post(transactions_url,
#                             body: transaction_body,
#                             headers: auth_headers
#                             )
# p transaction
=======
>>>>>>> 2b8119bf2d53655869d71f4e426c8e6a2f6fe346
