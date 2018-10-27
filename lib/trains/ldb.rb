require 'trains/ldb/config'
require 'trains/ldb/errors'
require 'trains/ldb/service'

module Trains
  module LDB
    ACTION = "http://thalesgroup.com/RTTI/2012-01-13/ldb/GetDepartureBoard"
    API_URI =
      URI("https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx")

    @@config = Config.new

    def self.setup(&block)
      block.call(config)
      config.validate!
    end

    def self.live_departures(from, to, limit = 20)
      # SOAP is a PITA, so these requests are purely hand-coded
      req = Net::HTTP::Post.new(API_URI)
      req["SOAPAction"] = ACTION
      req["Content-Type"] = "text/xml"
      req.body = <<END
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:t="http://thalesgroup.com/RTTI/2013-11-28/Token/types"
    xmlns:l="http://thalesgroup.com/RTTI/2017-10-01/ldb/">
  <soap:Header>
    <t:AccessToken>
      <t:TokenValue>#{config.api_key}</t:TokenValue>
    </t:AccessToken>
  </soap:Header>
  <soap:Body>
    <l:GetDepartureBoardRequest>
      <l:numRows>#{limit}</l:numRows>
      <l:crs>#{from.upcase}</l:crs>
      <l:filterCrs>#{to.upcase}</l:filterCrs>
    </l:GetDepartureBoardRequest>
  </soap:Body>
</soap:Envelope>
END
      res = Net::HTTP.start(API_URI.hostname, API_URI.port, use_ssl: true) do |http|
        http.request(req)
      end
      raise QueryError.new(res) if res.code != "200"
      doc = Nokogiri::XML(res.body)
      doc.remove_namespaces!
      doc.xpath("//service").map do |service|
        Service.new(
          origin_crs: service.xpath(".//origin/location/crs").text,
          origin_name: service.xpath(".//origin/location/locationName").text,
          destination_crs: service.xpath(".//destination/location/crs").text,
          destination_name: service.xpath(".//destination/location/locationName").text,
          scheduled_time: service.xpath(".//std").text,
          estimated_time: service.xpath(".//etd").text,
          platform: service.xpath(".//platform").text)
      end
    end

    private

    def self.config
      @@config
    end
  end
end
