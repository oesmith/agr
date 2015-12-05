require 'trains'

Trains::TransportAPI.setup do |config|
  if Rails.env.test?
    config.app_id = 'test_app_id'
    config.api_key = 'test_api_key'
  else
    config.app_id = ENV["TRANSPORTAPI_APP_ID"]
    config.api_key = ENV["TRANSPORTAPI_API_KEY"]
  end
end

Trains::LDB.setup do |config|
  if Rails.env.test?
    config.api_key = "test_api_key"
  else
    config.api_key = ENV["LDB_TOKEN"]
  end
end