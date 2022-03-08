namespace :transactions do
  desc "TODO"
  task trigger: :environment do
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
        cue_category = user_cue.cue.category
        cue_amount = user_cue.cue_amount
        # Figure out the correct condition based on the category.
        case cue_category
          when "coffee"
            cue_category = "starbucks"
          when "burger"
            cue_category = "mcdonalds"
          else
        end
        # Filter transactions by the ones that happened the day before.
        transactions << user.get_transactions(access_token, customer_id, account_id, cue_category)
        transactions.each do |transaction|
          unless transaction.empty?
            response = user.create_saving(access_token, customer_id, account_id, name, savings_iban, checking_iban, cue_amount, cue_category)
            puts response["remittanceInformationUnstructured"] if response
          end
        end
      end
      puts "==========="
    end
  end
end
