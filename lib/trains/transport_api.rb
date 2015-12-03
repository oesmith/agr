module Trains
  module TransportAPI
    class Config
      attr_accessor :api_key, :app_id

      def validate!
        raise "api_key and app_id must be configured" if api_key.nil? || app_id.nil?
      end
    end

    @@config = Config.new

    def self.setup(&block)
      block.call(config)
      config.validate!
    end

    def self.live_departures(station)
      JSON.parse(
        Net::HTTP.get(
          URI(
            "https://transportapi.com/v3/uk/train/station/#{station.upcase}/" +
            "live.json?app_id=#{config.app_id}&api_key=#{config.api_key}")))
    end

    private
      def self.config
        @@config
      end
  end
end
