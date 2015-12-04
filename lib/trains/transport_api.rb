module Trains
  module TransportAPI
    class Config
      attr_accessor :api_key, :app_id

      def validate!
        raise "api_key and app_id must be configured" if api_key.nil? || app_id.nil?
      end
    end

    class Departure
      attr_reader :platform, :aimed_arrival_time, :aimed_departure_time,
        :origin_name, :destination_name, :status, :expected_arrival_time,
        :expected_departure_time

      def initialize(h)
        h.each do |k, v|
          send("#{k}=", v)
        end
      end

      def ==(d)
        return platform == d.platform &&
          aimed_arrival_time == d.aimed_arrival_time &&
          aimed_departure_time == d.aimed_departure_time &&
          origin_name == d.origin_name &&
          destination_name == d.destination_name &&
          status == d.status &&
          expected_arrival_time == d.expected_arrival_time &&
          expected_departure_time == d.expected_departure_time
      end

      private
        attr_writer :platform, :aimed_arrival_time, :aimed_departure_time,
          :origin_name, :destination_name, :status, :expected_arrival_time,
          :expected_departure_time
    end

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

      def self.is_valid_response?(response)
      end
  end
end
