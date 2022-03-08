namespace :test_namespace do
  desc "Testing"
  task test_rake: :environment do
    puts "raking baby!"
  end

end
