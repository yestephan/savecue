class Rain
  def self.perform
    locations = query_all_locations
    # check all locations with rain and create an array with their names
    raining_locations = []
    locations[:coordinates].each do |location,coordinates|
      did_it_rain = weather_lookup(coordinates)
      if did_it_rain
        raining_locations.append(location)
      end
      p "Dit it rain in #{location}? #{did_it_rain}"
    end

    # iterate through the raining locations and create a transaction for each user_cue related to them
    raining_locations.each do |location|
      unless locations[:user_cues][location].nil?
        locations[:user_cues][location].each do |user_cue|
          create_transaction(user_cue)
        end
      end
    end
  end

  private

  def self.query_all_locations
    # Get all rain cues from user_cues
    all_cues = Cue.find_by({category: "rain"}).user_cues
    # set the default value for the hash as empty array (will store cues per location)
    location_cues = Hash.new { |h, k| h[k] = [] }
    # create an empty hash to store coordinates per location
    location_coordinates = Hash.new
    all_cues.each do |cue|
      unless cue.location.nil? || cue.latitude.nil? || cue.longitude.nil?
        # add the cue to the hash with location name as key
        location_cues[cue.location].append(cue)
        # add the lat/lng to the hash with location name as key
        location_coordinates[cue.location] = {lat: cue.latitude, lng: cue.longitude}
      end
    end
    # return a hash with cues and coordinates, they share the same key (location name)
    {user_cues: location_cues, coordinates: location_coordinates}
  end

  def self.api_url(lat, lng)
    # Want todays history only (from 12AM until now)
    dt = Time.now
    "http://api.openweathermap.org/data/2.5/onecall/timemachine?lat=#{lat}&lon=#{lng}&units=metric&dt=#{dt.to_i}&appid=#{ENV['WEATHER_API_KEY']}"
  end

  def self.weather_lookup(coordinates)
    result = HTTParty.get(api_url(coordinates[:lat], coordinates[:lng]))

    # if the hourly key is not available, we can't check the weather
    if result["hourly"].nil?
      return false
    end

    is_it_raining = false
    result["hourly"].each do |hour|
      # in case any kind of rain is detected set the variable to true
      weather = hour["weather"].select { |item| item["main"].downcase == "rain" }
      is_it_raining |= weather.count > 0
    end

    return is_it_raining
  end

  def self.create_transaction(user_cue)
    # Can't create transactions right now
    user = user_cue.user
    checking_account = user.checking_account
    checking_iban = checking_account.iban if checking_account
    checking_name = checking_account.name if checking_account

    savings_account = user.savings_account
    savings_iban = savings_account.iban if savings_account
    savings_name = savings_account.name if savings_account

    access_token = user.get_access_token
    customer_id = user.get_customer_id(access_token)
    account_id = user.get_account_id(access_token, customer_id, checking_iban)

    cue_amount = user_cue.cue_amount
    cue_category = user_cue.cue.category

    response = user.create_saving(access_token, customer_id, account_id, name, savings_iban, checking_iban, cue_amount, cue_category)
    puts "Savings for #{response["remittanceInformationUnstructured"].capitalize}" if response
  end
end
