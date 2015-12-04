require 'trains/transport_api/config'
require 'trains/transport_api/departure'

module Trains
  module TransportAPI
    @@config = Config.new

    def self.setup(&block)
      block.call(config)
      config.validate!
    end

    def self.live_departures(station)
      response = JSON.parse(
        Net::HTTP.get(
          URI(
            "https://transportapi.com/v3/uk/train/station/#{station.upcase}/" +
            "live.json?app_id=#{config.app_id}&api_key=#{config.api_key}")))

      if response.is_a?(Hash) &&
        response.has_key?("departures") &&
        response["departures"].is_a?(Hash) &&
        response["departures"].has_key?("all") &&
        response["departures"]["all"].is_a?(Array)
        response["departures"]["all"].map do |d|
          Departure.new(
            platform: d["platform"],
            aimed_arrival_time: d["aimed_arrival_time"],
            aimed_departure_time: d["aimed_departure_time"],
            origin_name: d["origin_name"],
            destination_name: d["destination_name"],
            status: d["status"],
            expected_departure_time: d["expected_departure_time"],
            expected_arrival_time: d["expected_arrival_time"],
          )
        end
      else
        []
      end
    end

    private

    def self.config
      @@config
    end
  end
end
