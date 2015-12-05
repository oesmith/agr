module Trains
  module TransportAPI
    class Config
      attr_accessor :api_key, :app_id

      def validate!
        if api_key.nil? || app_id.nil?
          raise "api_key and app_id must be configured"
        end
      end
    end
  end
end
