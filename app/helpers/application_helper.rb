module ApplicationHelper

# Cue Card and Cues'conditions.
  def emoji_for_category(category)
    case category
    when "rain"
      "🌧"
    when "coffee"
      "☕️"
    when "money"
      "💸"
    when"burger"
      "🍔"
    else
      "💰"
    end
  end

  def css_for_category(category)
    case category
    when "rain"
      "bg-barge"
    when "coffee"
      "bg-coffee"
    when "burger"
      "bg-jade"
    else
      "bg-money"
    end
  end

  def info_for_category(category)
    case category
    when "rain"
      "How much do you save for each rainy day?"
    when "coffee"
      "How much do you save for each coffee break?"
    when "sunny"
      "How much do you save for each sunny day?"
    else
      "How much do you save for each big spenda?"
    end
  end

  # Access token for Mockbank
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
    customer_name = "#{current_user.first_name} #{current_user.last_name}"
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
