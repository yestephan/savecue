class ProfilesController < ApplicationController
  before_action :authenticate_user!

  helper_method :css_for_category
  helper_method :emoji_for_category

  def home
    # It is 230 fixed it because we don't have transactions yet
    @total_saved = 0
    # List of all user cues from current user to be displayed
    @user_cues = current_user.user_cues
  end


  def all_transactions
    auth_url = "https://api.mockbank.io/oauth/token"
    customers_url = "https://api.mockbank.io/customers"
    customer_name = "Bibi"
    customer_iban_debit = "NL43INGB6631699223"
    customer_iban_debit_name = "Debit"
    customer_iban_credit = "NL86ABNA4643636556"
    customer_iban_credit_name = "Savings"
    transaction_amount = -4

    # Need generate access_token
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

  private
  def profile_update_params
    params.require(:user).permit(:first_name, :last_name, :picture)
  end
end
