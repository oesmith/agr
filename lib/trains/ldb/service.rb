module Trains
  module LDB
    class Service
      attr_reader :origin_name, :origin_crs, :destination_crs,
        :destination_name, :scheduled_time, :estimated_time, :platform

      def initialize(h)
        h.each do |k, v|
          send("#{k}=", v)
        end
      end

      private

      attr_writer :origin_name, :origin_crs, :destination_crs,
        :destination_name, :scheduled_time, :estimated_time, :platform
    end
  end
end
