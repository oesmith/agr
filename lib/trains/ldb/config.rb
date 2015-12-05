module Trains
  module LDB
    class Config
      attr_accessor :api_key

      def validate!
        if api_key.nil?
          raise "api_key must be configured"
        end
      end
    end
  end
end
