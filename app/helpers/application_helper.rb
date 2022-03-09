module ApplicationHelper

  # Emoji helper for transactions page! Please don't remote, if you do, check with Stephan first!
  def get_category(tag)
    case tag
    when "rain"
      { emoji: "🌧",
        title: "Rainy day" }
    when "cloudy"
      { emoji: "☁️",
        title: "Cloudy day" }
    when "coffee"
      { emoji: "☕️",
        title: "Coffee break" }
    when "burger"
      { emoji: "🍔",
        title: "Burger day" }
    when "money"
      { emoji: "💸",
        title: "Big spenda!" }
    when "wine"
      { emoji: "🥂",
        title: "Wine evening" }
    else
      { emoji: "😵",
        title: "Strange transaction!" }
    end
  end

  # Needed for the setup of cues
  def info_for_category(category)
    case category
    when "rain"
      "It just rained 🌧 How much are you saving?"
    when "cloudy"
      "Gloomy day! ☁️ How much are you saving?"
    when "coffee"
      "One cup of holiness ☕️ saves you how much?"
    when "burger"
      "That was a nice burger 🍔, how much are you saving?"
    when "money"
      "Hey big spenda! 💸 How much are you saving each time?"
    when "wine"
      "One glass of 🍷 saves you how much?"
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
