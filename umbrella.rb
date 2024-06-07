

require "http"
require "json"
pp "howdy"
pp "Where are you located?"

user_location = gets.chomp.gsub(" ", "%20")

#user_location = "Chicago"

pp user_location
maps_url ="https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")



resp = HTTP.get(maps_url)
# pp resp

raw_response = resp.to_s

parsed_response = JSON.parse(raw_response)
# pp parsed_response.keys
results = parsed_response.fetch("results")
first_result = results.at(0)

geo = first_result.fetch("geometry")
loc =  geo.fetch("location")

pp latitude = loc.fetch("lat")
pp longitude = loc.fetch("lng")

# I've already created a string variable above: pirate_weather_api_key
# It contains sensitive credentials that hackers would love to steal so it is hidden for security reasons.

# require "http"


pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{latitude},#{longitude}"

# Place a GET request to the URL
raw_pirate_response = HTTP.get(pirate_weather_url)

# require "json"

parsed_pirate_response = JSON.parse(raw_pirate_response)
currently_hash = parsed_pirate_response.fetch("currently")
current_temp = currently_hash.fetch("temperature")

puts "The current temperature is #{current_temp}."

hour_hash = parsed_pirate_response.fetch("hourly")
hourly_data_array = hour_hash.fetch("data")
next_twelve_hours = hourly_data_array[1..12]

precip_threshold = 0.10
any_precipitation = false

next_twelve_hours.each do |hour|
  rain_prob = hour.fetch("precipProbability")

  if rain_prob > precip_threshold
    any_precipitation = true
    rain_time = Time.at(hour.fetch("time"))
    seconds_from_now = rain_time - Time.now
    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now} hours, there's a #{(rain_prob * 100).round}% chance of rain"
  end
end

if any_precipitation == true
  puts "You should grab an umbrella!"
else
  puts "You won't need an umbrella."
end
