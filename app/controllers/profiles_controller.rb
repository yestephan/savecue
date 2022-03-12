class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def home
    # List of all user cues from current user to be displayed
    @user_cues = current_user.user_cues

    # List transactions
    @access_token = helpers.get_access_token
    @customer_id = helpers.get_customer_id(@access_token)

    checking_account = current_user.checking_account
    unless checking_account.nil?
      @checking_iban = checking_account.iban
    end

    savings_account = current_user.savings_account
    unless savings_account.nil?
      @savings_iban = savings_account.iban
    end

    @account_id = helpers.get_account_id(@access_token, @customer_id, @savings_iban)
    temp_transactions = get_all_savecue_transactions(@access_token, @customer_id, @account_id)
    temp_transactions = temp_transactions.sort_by { |hsh| hsh["bookingDate"] }.reverse
    @transactions = temp_transactions
    # Counting totals
    @total_saved = count_total(@transactions)
    # Counting amount for each cues
    @total_each_cue_saved = count_total_for_each_cue(@transactions)
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
  customers_url = "https://api.mockbank.io/customers"

  def get_all_savecue_transactions(access_token, customer_id, account_id)
    customers_url = "https://api.mockbank.io/customers"
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    transactions_url = "#{customers_url}/#{customer_id}/transactions"
    transactions = HTTParty.get(transactions_url, headers: auth_headers).parsed_response["data"].to_a
    raise
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
    customers_url = "https://api.mockbank.io/customers"
    booking_date = Time.now.strftime("%Y-%m-%d")
    auth_headers = { "Authorization" => "Bearer #{access_token}", "content-type" => "application/json"}
    transactions_url = "#{customers_url}/#{customer_id}/transactions"
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

  def count_total_for_each_cue(transactions)
    burger_total = 0
    coffee_total = 0
    rain_total = 0
    big_spenda_total = 0
    cloudy_total = 0

    transactions.each do |transaction|
      if transaction["remittanceInformationUnstructured"].downcase == 'coffee'
        coffee_total += transaction["amount"].to_f
      elsif transaction["remittanceInformationUnstructured"].downcase == 'burger'
        burger_total += transaction["amount"].to_f
      elsif transaction["remittanceInformationUnstructured"].downcase == 'rain'
        rain_total += transaction["amount"].to_f
      elsif transaction["remittanceInformationUnstructured"].downcase == 'money'
        big_spenda_total += transaction["amount"].to_f
      elsif transaction["remittanceInformationUnstructured"].downcase == 'cloudy'
        cloudy_total += transaction["amount"].to_f
      end
    end
    return { burger: burger_total, coffee: coffee_total, rain: rain_total, spenda: big_spenda_total, cloudy: cloudy_total }
  end
end
