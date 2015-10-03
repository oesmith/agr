package ldb

import (
	"bytes"
	"encoding/xml"
	"flag"
	"io/ioutil"
	"net/http"
)

// There's only ever going to be one access_token; use a flag.
var accessToken = flag.String("ldb_token", "", "National Rail LDB service access token")
var serviceAddress = flag.String("ldb_address", "", "National Rail LDB service address")

// NewGetDepartureBoardRequest returns an HTTP Request object ready to send to
// the LDB API to query services departing from and arriving at the specified
// stations.
func NewGetDepartureBoardRequest(rows int, from string, to string) (*http.Request, error) {
	env := &envelope{
		EncodingStyle: "http://schemas.xmlsoap.org/soap/encoding",
		Header: &envelopeHeader{
			AccessToken: &token{
				TokenValue: *accessToken,
			},
		},
		Body: &envelopeBody{
			GetDepartureBoardRequest: &getDepartureBoardRequest{
				NumRows: rows,
				CRS: from,
				FilterCRS: to,
			},
		},
	}
	return newRequest(env, "http://thalesgroup.com/RTTI/2012-01-13/ldb/GetDepartureBoard")
}

// ParseGetDepartureBoardResponse parses the response returned by the LDB API.
func ParseGetDepartureBoardResponse(resp *http.Response) (*GetDepartureBoardResponse, error) {
	if env, err := parseEnvelope(resp); err != nil {
		return nil, err
	} else {
		return env.Body.GetDepartureBoardResponse, nil
	}
}

func newRequest(envelope *envelope, action string) (*http.Request, error) {
	bytes := &bytes.Buffer{}
	encoder := xml.NewEncoder(bytes)
	if err := encoder.Encode(envelope); err != nil {
		return nil, err
	}
	req, err := http.NewRequest("POST", *serviceAddress, bytes)
	if err != nil {
		return nil, err
	}
	req.Header.Add("SOAPAction", action)
	req.Header.Add("Content-Type", "text/xml")
	return req, nil
}

func parseEnvelope(resp *http.Response) (*envelope, error) {
	env := &envelope{}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	err = xml.Unmarshal(body, env)
	if err != nil {
		return nil, err
	}
	return env, nil
}
