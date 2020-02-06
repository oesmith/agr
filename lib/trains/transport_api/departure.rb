module Trains
  module TransportAPI
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
  end
end
