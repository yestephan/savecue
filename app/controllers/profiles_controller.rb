class ProfilesController < ApplicationController
  before_action :authenticate_user!
  helper_method :css_for_category
  helper_method :emoji_for_category
  helper_method :info_for_category
  helper_method :new_transaction

  def home
    # List of all user cues from current user to be displayed
    @user_cues = current_user.user_cues

    # List transactions
    current_user

    checking_account = current_user.checking_account
    unless checking_account.nil?
      @checking_iban = checking_account.iban
    end

    savings_account = current_user.savings_account
    unless savings_account.nil?
      @savings_iban = savings_account.iban
    end

    @access_token = get_access_token
    @customer_id = get_customer_id(@access_token)
    @account_id = get_account_id(@access_token, @customer_id, @savings_iban)
    @transactions = get_transactions(@access_token, @customer_id, @account_id)
    @response = params[:response]
    # Counting totals
    @total_saved = count_total(@transactions)
  end

  def new_transaction
    @access_token = get_access_token
    @customer_id = get_customer_id(@access_token)

    checking_account = current_user.checking_account
    unless checking_account.nil?
      @checking_iban = checking_account.iban
    end

    savings_account = current_user.savings_account
    unless savings_account.nil?
      @savings_iban = savings_account.iban
      @savings_name = savings_account.name
    end

    @account_id = get_account_id(@access_token, @customer_id, @savings_iban)
    # Pass the correct cue.category details
    temp_cue = current_user.user_cues.first # Faking it now
    cue_category = Cue.find(temp_cue.cue_id).category
    response = create_transaction(@access_token, @customer_id, @account_id, @savings_name, @savings_iban, cue_category)
    if response.parsed_response["externalId"]
      @response = response.parsed_response["externalId"]
    end
    redirect_to home_path(response: @response)
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

  def emoji_for_category(category)
    case category
    when "rain"
      "🌧"
    when "coffee"
      "☕️"
    when "sunny"
      "☀️"
    when"burger"
      "🍔"
    else
      "💰"
    end
  end

  def info_for_category(category)
    case category
    when "rain"
      "How much do you save for each rainy day"
    when "coffee"
      "How much do you save for each coffee break"
    when "sunny"
      "How much do you save for each sunny day"
    else
      "How much do you save for each big spenda"
    end
  end

  def edit
    @profile = current_user
  end

  def confirm
  end

  def update
    received_params = profile_update_params
    unless received_params[:picture].nil?
      unless current_user.picture.nil?
        Cloudinary::Api.delete_resources([current_user.picture])
      end
      uploaded_image = Cloudinary::Uploader.upload(received_params[:picture].tempfile.path)
      received_params[:picture] = uploaded_image["public_id"]
    end
    current_user.update(received_params)
    current_user.save
    redirect_to :home
  end

  # ============== PRIVATE METHODS ==============
  private

  def profile_update_params
    params.require(:user).permit(:first_name, :last_name, :picture)
  end

  # Scope Variables
  @@customers_url = "https://api.mockbank.io/customers"

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

  def get_customer_id(access_token)
    customer_name = "#{current_user.first_name} #{current_user.last_name}"
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    customers = HTTParty.get(@@customers_url, headers: auth_headers)
    customers = customers.parsed_response["data"].to_a
    customer = ""
    customers.each do |object|
      customer = object if object["fullName"] == customer_name
    end
    return customer["externalId"]
  end

  def get_account_id(access_token, customer_id, savings_iban)
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    accounts_url = "#{@@customers_url}/#{customer_id}/accounts"
    customer_accounts = HTTParty.get(accounts_url, headers: auth_headers)
    customer_accounts = customer_accounts.parsed_response["data"].to_a
    account = ""
    customer_accounts.each do |element|
      account = element if element["iban"] == savings_iban
    end
    return account["externalId"]
  end

  def get_transactions(access_token, customer_id, account_id)
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    transactions_url = "#{@@customers_url}/#{customer_id}/transactions"
    transactions = HTTParty.get(transactions_url, headers: auth_headers).parsed_response["data"].to_a.reverse
    account_transactions = []
    transactions.each do |transaction|
      unless transaction["remittanceInformationStructured"].nil?
        if transaction["accountId"] == account_id && transaction["remittanceInformationStructured"].downcase == "savecue"
          account_transactions << transaction
        end
      end
    end
    return account_transactions
  end

  def create_transaction(access_token, customer_id, account_id, savings_name, savings_iban, cue_category)
    booking_date = Time.now.strftime("%Y-%m-%d")
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    transactions_url = "#{@@customers_url}/#{customer_id}/transactions"
    transaction_body = {
      "accountId": "#{account_id}",
      "amount": 4,
      "bookingDate": "#{booking_date}",
      "currency": "EUR",
      "valueDate": "#{booking_date}",
      "creditorId": "creditorId",
      "creditorName": "#{savings_name}",
      "creditorAccount": {
        "currency": "EUR",
        "iban": "#{savings_iban}",
      },
      "debtorAccount": {},
      "remittanceInformationStructured": "savecue",
      "remittanceInformationUnstructured": "#{cue_category}"
    }.to_json
    HTTParty.post(transactions_url, body: transaction_body, headers: auth_headers)
  end

  def count_total(transactions)
    total_saved = 0
    transactions.each do |transaction|
      total_saved += transaction["amount"]
    end
    return total_saved
  end
end
