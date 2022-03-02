require 'httparty'

Transaction.destroy_all
UserCue.destroy_all
Cue.destroy_all
User.destroy_all

# cues
# rain_cue = Cue.new({title: "Rainy day!", description: "Save money each time it's raining in your city", category: "rain"})
# burger_cue = Cue.new({title: "Burger day!", description: "Save money each time you eat a burger", category: "burger"})
# spenda_cue = Cue.new({title: "Big spenda!", description: "Save money each time you spend more than a certain ammount", category: "spenda"})

# rain_cue.save
# burger_cue.save
# spenda_cue.save

# users/
# user = User.new({full_name: "Bibi Ferreira", email: "bibi@email.com", password: "test1234"})
# user.save

# user cues
amsterdam_metadata = {location: "Amsterdam, NL"}
rain_amsterdam_cue = UserCue.new({user: user, cue: rain_cue, cue_amount: 5, metadata: amsterdam_metadata})
rain_amsterdam_cue.creditor_account = savings
rain_amsterdam_cue.debtor_account = checking
rain_amsterdam_cue.save

burger_user_cue = UserCue.new({user: user, cue: burger_cue, cue_amount: 2})
burger_user_cue.creditor_account = savings
burger_user_cue.debtor_account = checking
burger_user_cue.save

spenda_metadata = {limit: 50}
spenda_user_cue = UserCue.new({user: user, cue: spenda_cue, metadata: spenda_metadata})
spenda_user_cue.creditor_account = savings
spenda_user_cue.debtor_account = checking
spenda_user_cue.save


# NL06 4815 1623 0000 0014 77
# Debit Account


auth_url = "https://api.mockbank.io/oauth/token"
customers_url = "https://api.mockbank.io/customers"



# Generate Access Token
auth_query = { "client_id" => "stephanye", "client_secret" => "secret",
                "grant_type" => "password",
                "username" => "contact@stephanye.io", "password" => "testmock" }
auth_headers = { "content-type" => "application/json" }
mockbank_admin = HTTParty.post(auth_url,
                      query: auth_query,
                      headers: auth_headers)
access_token = mockbank_admin["access_token"]

# Get customers
auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
customers = HTTParty.get(customers_url,
  headers: auth_headers
)

p customers.class

# Get customer id


# Get user accounts
