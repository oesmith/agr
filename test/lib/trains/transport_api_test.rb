require 'test_helper'

class Trains::TransportAPITest < ActiveSupport::TestCase
  API_KEY = "my_api_key"
  APP_ID = "my_app_id"
  STATION = "PAD"
  URL = "https://transportapi.com/v3/uk/train/station/#{STATION}/live.json"

  setup do
    Trains::TransportAPI.setup do |config|
      config.api_key = API_KEY
      config.app_id = APP_ID
    end
  end

  test 'should not allow nil app ID or API key values' do
    assert_raises do
      Trains::TransportAPI.setup do |config|
        config.api_key = nil
        config.app_id = nil
      end
    end
  end

  test 'should fetch live departures' do
    # TODO(ollysmith): actually parse and validate the response JSON
    stub_request(:get, URL)
        .with(query: { api_key: API_KEY, app_id: APP_ID })
        .to_return(body: '{"foo": [1, 2, 3]}')
    json = Trains::TransportAPI.live_departures(STATION)
    assert_equal({ "foo" => [1, 2, 3] }, json)
  end

  test 'should upper-case station names' do
    # Stub for URL containing upper-case station name.
    stub_request(:get, URL)
        .with(query: { api_key: API_KEY, app_id: APP_ID })
        .to_return(body: "{}")
    Trains::TransportAPI.live_departures(STATION.downcase)
  end
end
