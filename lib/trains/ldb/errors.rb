module Trains
  module LDB
    # General exception class
    class Error < StandardError; end

    # Raised when a query to the LDB API fails
    class QueryError < Error
      attr_reader :response

      def initialize(response)
        super("Error querying LDB API")
        @response = response
      end
    end
  end
end
