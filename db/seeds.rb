Transaction.destroy_all
UserCue.destroy_all
Cue.destroy_all
User.destroy_all


# cues
rain_cue = Cue.new({title: "Rainy day!", description: "Save money each time it's raining in your city", category: "rain"})
burger_cue = Cue.new({title: "Burger day!", description: "Save money each time you eat a burger", category: "burger"})
spenda_cue = Cue.new({title: "Big spenda!", description: "Save money each time you spend more than a certain ammount", category: "spenda"})
starbucks_cue = Cue.new({title: "Starbucks day!", description: "Save money each time you spend more than a certain ammount", category: "spenda"})

rain_cue.save
burger_cue.save
spenda_cue.save
starbucks_cue.save

# users/

user = User.new({full_name: "Bibi Ferreira", email: "bibi@email.com", password: "test1234", bank_account: "NL 00 ABNA 0000000000"})
user.save

# user cues
amsterdam_metadata = {location: "Amsterdam, NL"}
rain_amsterdam_cue = UserCue.new({user: user, cue: rain_cue, cue_amount: 5, metadata: amsterdam_metadata})
rain_amsterdam_cue.save

burger_user_cue = UserCue.new({user: user, cue: burger_cue, cue_amount: 2})
burger_user_cue.save

spenda_metadata = {limit: 50}
spenda_user_cue = UserCue.new({user: user, cue: spenda_cue, metadata: spenda_metadata})
spenda_user_cue.save

# transactions
def create_transactions(user, user_cue, amount)
  amount.times do |_n|
    transaction = Transaction.new({amount: user_cue.cue_amount, user: user, user_cue: user_cue})
    transaction.save
  end
end

create_transactions(user, rain_amsterdam_cue, 3)
create_transactions(user, burger_user_cue, 5)
create_transactions(user, spenda_user_cue, 2)
