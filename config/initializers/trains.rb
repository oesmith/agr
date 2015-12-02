require 'trains/transport_api.rb'

Trains::TransportAPI.setup do |config|
  config.app_id = ENV["TRANSPORTAPI_APP_ID"]
  config.api_key = ENV["TRANSPORTAPI_API_KEY"]
end
