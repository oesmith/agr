package ldb

import (
	"encoding/xml"
)

type GetDepartureBoardResponse struct {
	GetStationBoardResult *GetStationBoardResult `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ GetStationBoardResult"`
}

type GetStationBoardResult struct {
	GeneratedAt string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types generatedAt"`
	LocationName string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types locationName"`
	CRS string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types crs"`
	FilterLocationName string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types filterLocationName"`
	FilterCRS string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types filtercrs"`
	PlatformAvailable bool `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types platformAvailable"`
	TrainServices *TrainServices `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types trainServices"`
}

type TrainServices struct {
	Service []*Service `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types service"`
}

type Service struct {
	Origin *LocationContainer `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types origin"`
	Destination *LocationContainer `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types destination"`
	STD string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types std"`
	ETD string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types etd"`
	Operator string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types operator"`
	OperatorCode string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types operatorCode"`
	Platform string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types platform"`
	ServiceID string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types serviceID"`
}

type LocationContainer struct {
	Location *Location `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types location"`
}

type Location struct {
	LocationName string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types locationName"`
	CRS string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types crs"`
	Via string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types via"`
	FutureChangeTo string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/types futureChangeTo"`
}

type envelope struct {
	XMLName xml.Name `xml:"http://schemas.xmlsoap.org/soap/envelope/ Envelope"`
	EncodingStyle string `xml:"http://schemas.xmlsoap.org/soap/envelope/ encodingStyle,attr"`
	Header *envelopeHeader `xml:"http://schemas.xmlsoap.org/soap/envelope/ Header,omitempty"`
	Body *envelopeBody `xml:"http://schemas.xmlsoap.org/soap/envelope/ Body"`
}

type envelopeHeader struct {
	AccessToken *token `xml:"http://thalesgroup.com/RTTI/2013-11-28/Token/types AccessToken"`
}

type envelopeBody struct {
	GetDepartureBoardRequest *getDepartureBoardRequest `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ GetDepartureBoardRequest,omitempty"`
	GetDepartureBoardResponse *GetDepartureBoardResponse `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ GetDepartureBoardResponse,omitempty"`
}

type token struct {
	TokenValue string `xml:"http://thalesgroup.com/RTTI/2013-11-28/Token/types TokenValue"`
}

type getDepartureBoardRequest struct {
	NumRows int `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ numRows"`
	CRS string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ crs"`
	FilterCRS string `xml:"http://thalesgroup.com/RTTI/2014-02-20/ldb/ filterCrs,omitempty"`
}
