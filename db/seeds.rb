require 'httparty'
require 'json'

UserCue.destroy_all
Cue.destroy_all
User.destroy_all
Account.destroy_all

# Cues
rain = Cue.new({ title: "Rainy day!",
                 description: "It's raining, and you're saving!",
                 category: "rain",
                 color: "bg-barge",
                 emoji: "🌧" })
rain.save!
cloudy = Cue.new({ title: "Cloudy day!",
                 description: "Dark clouds 😔 Money saved 😊",
                 category: "cloudy",
                 color: "bg-grey",
                 emoji: "☁️" })
cloudy.save!
spenda = Cue.new({ title: "Big spenda!",
                   description: "For every €50 ➡ You save money!",
                   category: "money",
                   color: "bg-purple-light",
                   emoji: "💸" })
spenda.save!
coffee = Cue.new({ title: "Coffee break",
                      description: "Coffee is great, saving is better.",
                      category: "coffee",
                      color: "bg-coffee",
                      emoji: "☕️" })
coffee.save!
burger = Cue.new({ title: "Burger day!",
                   description: "Super size your savings. One burger = €",
                   category: "burger",
                   color: "bg-orange",
                   emoji: "🍔" })
burger.save!
wine = Cue.new({ title: "Wine evening",
                   description: "One glass, one saving",
                   category: "wine",
                   color: "bg-jade",
                   emoji: "🥂" })
wine.save!
Cue.all.each do |cue|
  puts "#{cue.title} cue created 🌱"
end
puts "============"

# Users and Accounts created
bibi = User.new({ first_name: "Bibi", last_name: "Ferreira", email: "bibi@email.com", password: "test1234", picture: "bibi_ytlbhy" })
bibi.save!
checking = Account.new({ name: "Checking", account_type: Account::TYPE_CHECKING, iban: "NL43INGB6631699223", user: bibi })
checking.save!
savings = Account.new({ name: "Savings", account_type: Account::TYPE_SAVINGS, iban: "NL86ABNA4643636556", user: bibi })
savings.save!

stephan = User.new({ first_name: "Stephan", last_name: "Ye", email: "stephan@email.com", password: "test1234", picture: "stephan_yveu8d" })
stephan.save!
checking = Account.new({ name: "Checking", account_type: Account::TYPE_CHECKING, iban: "NL69481516230000001507", user: stephan })
checking.save!
savings = Account.new({ name: "Savings", account_type: Account::TYPE_SAVINGS, iban: "NL80481516230000001503", user: stephan })
savings.save!


User.all.each do |user|
  puts "Checking and Savings Account created for #{user.first_name} #{user.last_name}"
end

puts "============"

# User cues
User.all.each do |user|
  # rand_nr = rand(1..5)
  rand_nr = 2
  use_cue = UserCue.new({ user: user, cue: burger, cue_amount: rand_nr })
  use_cue.save!
  # rand_nr = rand(1..5)
  rand_nr = 3
  use_cue = UserCue.new({ user: user, cue: coffee, cue_amount: rand_nr })
  use_cue.save!
  # rand_nr = rand(1..5)
  rand_nr = 8
  use_cue = UserCue.new({ user: user, cue: spenda, cue_amount: rand_nr })
  use_cue.save!
  puts user.first_name
  user.user_cues.each do |user_cue|
    puts "#{user_cue.cue.title} cue setup"
  end
  puts "============"
end

mika = User.new({ first_name: "Mika", last_name: "O'Yeah", email: "mika@email.com", password: "test1234" })
mika.save!
checking = Account.new({ name: "Salary", account_type: Account::TYPE_CHECKING, iban: "NL42481516230000001508", user: mika })
checking.save!
savings = Account.new({ name: "Future", account_type: Account::TYPE_SAVINGS, iban: "NL15481516230000001509", user: mika })
savings.save!
rand_nr = rand(1..5)
use_cue = UserCue.new({ user: mika, cue: spenda, cue_amount: rand_nr })
use_cue.save!

puts "Checking and Savings Account created for #{mika.first_name} #{mika.last_name}"
