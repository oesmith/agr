require 'test_helper'

class Trains::TransportAPITest < ActiveSupport::TestCase
  API_KEY = "my_api_key"
  APP_ID = "my_app_id"
  STATION = "PAD"
  URL = "https://transportapi.com/v3/uk/train/station/#{STATION}/live.json"
  RESPONSE = <<END
    {
      "departures": {
        "all": [
          {
            "platform": "2",
            "aimed_departure_time": "18:00",
            "aimed_arrival_time": null,
            "origin_name": "London Paddington",
            "destination_name": "Bristol Temple Meads",
            "status": "STARTS HERE",
            "expected_arrival_time": null,
            "expected_departure_time": "18:00"
          },
          {
            "platform": "9",
            "aimed_departure_time": "18:28",
            "aimed_arrival_time": "18:30",
            "origin_name": "London Paddington",
            "destination_name": "Weston Super Mare",
            "status": "LATE",
            "expected_arrival_time": "18:36",
            "expected_departure_time": "18:38"
          }
        ]
      }
    }
END
  DEPARTURES = [
    Trains::TransportAPI::Departure.new(
      platform: "2",
      aimed_departure_time: "18:00",
      aimed_arrival_time: nil,
      origin_name: "London Paddington",
      destination_name: "Bristol Temple Meads",
      status: "STARTS HERE",
      expected_arrival_time: nil,
      expected_departure_time: "18:00",
    ),
    Trains::TransportAPI::Departure.new(
      platform: "9",
      aimed_departure_time: "18:28",
      aimed_arrival_time: "18:30",
      origin_name: "London Paddington",
      destination_name: "Weston Super Mare",
      status: "LATE",
      expected_arrival_time: "18:36",
      expected_departure_time: "18:38",
    ),
  ]

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
        .to_return(body: RESPONSE)
    departures = Trains::TransportAPI.live_departures(STATION)
    assert_equal(DEPARTURES, departures)
  end

  test 'should upper-case station names' do
    # Stub for URL containing upper-case station name.
    stub_request(:get, URL)
        .with(query: { api_key: API_KEY, app_id: APP_ID })
        .to_return(body: "{}")
    Trains::TransportAPI.live_departures(STATION.downcase)
  end
end
