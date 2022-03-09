namespace :transactions do
  desc "TODO"
  task trigger: :environment do

    # Check for rainy day
    Rain.perform
    # Check for cloudy day
    Cloudy.perform
    # Check for other cues
    User.all.each do |user|
      name = "#{user.first_name} #{user.last_name}"
      puts name

      checking_account = user.checking_account
      checking_iban = checking_account.iban if checking_account
      checking_name = checking_account.name if checking_account

      savings_account = user.savings_account
      savings_iban = savings_account.iban if savings_account
      savings_name = savings_account.name if savings_account

      access_token = user.get_access_token
      customer_id = user.get_customer_id(access_token)
      account_id = user.get_account_id(access_token, customer_id, checking_iban)


      user.user_cues.each do |user_cue|
        transactions = []
        cue_amount = user_cue.cue_amount
        cue_category = user_cue.cue.category

        # Figure out the correct condition based on the category.
        if cue_category == "money"
          nr_of_transactions = user.get_transactions_by_amount(access_token, customer_id, account_id).count
          nr_of_transactions.times do |_t|
            response = user.create_saving(access_token, customer_id, account_id, name, savings_iban, checking_iban, cue_amount, cue_category)
            puts "Savings for #{response["remittanceInformationUnstructured"].capitalize}" if response
          end
        # elsif cue_category == "rain"
        else
          creditor_name = ""
          case cue_category
            when "coffee"
              creditor_name = "starbucks"
            when "burger"
              creditor_name = "mcdonalds"
            else
          end
          # Get the transactions that correspond to either "burger" or "coffee" and trigger a transaction
          nr_of_transactions = user.get_transactions_by_creditor(access_token, customer_id, account_id, creditor_name).count
          nr_of_transactions.times do |_t|
            response = user.create_saving(access_token, customer_id, account_id, name, savings_iban, checking_iban, cue_amount, cue_category)
            puts "Savings for #{response["remittanceInformationUnstructured"].capitalize}" if response
          end
        end
      end
      puts "==========="
    end
  end
end
