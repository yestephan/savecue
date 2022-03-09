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
    else
      { emoji: "😵",
        title: "Strange transaction!" }
    end
  end

  # Needed for the setup of cues
  def info_for_category(category)
    case category
    when "rain"
      "How much do you save for each rainy day?"
    when "cloudy"
      "How much do you save for each cloudy day?"
    when "coffee"
      "How much do you save for each coffee break?"
    when "burger"
      "How much do you save for each burger?"
    when "money"
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

  def link_back
    url = request.original_url

    checking = "checking-account"
    saving = "savings-account"
    edit_checking = "checking"
    edit_savings = "savings"

    if url.include? checking
      "#{root_url}cues/#{current_user.cues.first.id}/user_cues/new"
    elsif url.include? saving
      "#{root_url}signup/checking-account?url_origin=signup"
    elsif url.include? edit_checking
      accounts_checking_path
    elsif url.include? edit_savings
      accounts_savings_path
    elsif current_page?(new_cue_user_cue_path(/\d/))
      "#{root_url}home"
    else
      home_path
    end
  end
end
