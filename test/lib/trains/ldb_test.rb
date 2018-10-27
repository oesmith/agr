require 'test_helper'

class Trains::LDBTest < ActiveSupport::TestCase
  API_KEY = "my_api_key"
  NS_SOAP = "http://schemas.xmlsoap.org/soap/envelope/"
  NS_TYPE = "http://thalesgroup.com/RTTI/2013-11-28/Token/types"
  NS_LDB = "http://thalesgroup.com/RTTI/2017-10-01/ldb/"

  setup do
    Trains::LDB.setup do |config|
      config.api_key = API_KEY
    end
  end

  test 'should not allow nil app ID or API key values' do
    assert_raises do
      Trains::LDB.setup do |config|
        config.api_key = nil
      end
    end
  end

  test 'should set auth token' do
    stub_request(:post, Trains::LDB::API_URI).with do |req|
      api_key = Nokogiri::XML(req.body)
          .xpath('.//s:Envelope/s:Header/t:AccessToken/t:TokenValue', s:NS_SOAP, t: NS_TYPE)
          .text
      API_KEY == api_key
    end
    Trains::LDB.live_departures("src", "dst")
  end

  test 'should set request parameters' do
    stub_request(:post, Trains::LDB::API_URI).with do |req|
      doc = Nokogiri::XML(req.body)
      src = doc.xpath(".//s:Envelope/s:Body/l:GetDepartureBoardRequest/l:crs", s: NS_SOAP, l: NS_LDB).text
      dst = doc.xpath(".//s:Envelope/s:Body/l:GetDepartureBoardRequest/l:filterCrs", s: NS_SOAP, l: NS_LDB).text
      rows = doc.xpath(".//s:Envelope/s:Body/l:GetDepartureBoardRequest/l:numRows", s: NS_SOAP, l: NS_LDB).text
      "SRC" == src && "DST" == dst && "7" == rows
    end
    Trains::LDB.live_departures("src", "dst", 7)
  end

  test 'should set soap action header' do
    stub_request(:post, Trains::LDB::API_URI)
        .with(headers: { "SOAPAction" => Trains::LDB::ACTION })
    Trains::LDB.live_departures("src", "dst")
  end

  test 'should parse responses' do
    res_body = <<END
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soap:Body>
    <GetDepartureBoardResponse xmlns="http://thalesgroup.com/RTTI/2014-02-20/ldb/">
      <GetStationBoardResult xmlns:l="http://thalesgroup.com/RTTI/2015-05-14/ldb/" xmlns:lt="http://thalesgroup.com/RTTI/2012-01-13/ldb/types" xmlns:lt2="http://thalesgroup.com/RTTI/2014-02-20/ldb/types" xmlns:lt3="http://thalesgroup.com/RTTI/2015-05-14/ldb/types">
        <lt2:trainServices>
          <lt2:service>
            <lt2:origin>
              <lt2:location>
                <lt2:locationName>London Paddington</lt2:locationName>
                <lt2:crs>PAD</lt2:crs>
              </lt2:location>
            </lt2:origin>
            <lt2:destination>
              <lt2:location>
                <lt2:locationName>Bristol Temple Meads</lt2:locationName>
                <lt2:crs>BRI</lt2:crs>
              </lt2:location>
            </lt2:destination>
            <lt2:platform>11</lt2:platform>
            <lt2:std>23:30</lt2:std>
            <lt2:etd>On time</lt2:etd>
          </lt2:service>
        </lt2:trainServices>
      </GetStationBoardResult>
    </GetDepartureBoardResponse>
  </soap:Body>
</soap:Envelope>
END
    stub_request(:post, Trains::LDB::API_URI).to_return(body: res_body)
    services = Trains::LDB.live_departures("src", "dst")
    assert_equal(1, services.length)
    service = services.first
    assert_equal("London Paddington", service.origin_name)
    assert_equal("PAD", service.origin_crs)
    assert_equal("Bristol Temple Meads", service.destination_name)
    assert_equal("BRI", service.destination_crs)
    assert_equal("11", service.platform)
    assert_equal("23:30", service.scheduled_time)
    assert_equal("On time", service.estimated_time)
  end
end
