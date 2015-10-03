package trains

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"regexp"

	"github.com/oesmith/agr/trains/ldb"
	"github.com/oesmith/agr/trains/transportapi"
	"github.com/oesmith/agr/template"
)

var (
	client = &http.Client{}
	path = regexp.MustCompile(`^/trains/dep/([A-Z]{3})/([A-Z]{3})$`)
)

type response struct {
	OriginCode string
	DestinationCode string
	Departures []*departure
	LdbError string
	TransportapiError string
}

type departure struct {
	ScheduledDeparture string
	EstimatedDeparture string
	DestinationCode string
	DestinationName string
	ScheduledPlatform string
	EstimatedPlatform string
}

func fetch(req *http.Request) (*http.Response, error) {
	res, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	if res.StatusCode != 200 {
		defer res.Body.Close()
		body, _ := ioutil.ReadAll(res.Body)
		return nil, fmt.Errorf("Invalid status code: %d (%v)", res.StatusCode, string(body))
	}
	return res, nil
}

func fetchLiveDepartures(from string, to string) (*ldb.GetDepartureBoardResponse, error) {
	req, err := ldb.NewGetDepartureBoardRequest(5, from, to)
	if err != nil {
		return nil, err
	}
	res, err := fetch(req)
	if err != nil {
		return nil, err
	}
	data, err := ldb.ParseGetDepartureBoardResponse(res)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func fetchTransportAPI(from string) (*transportapi.Response, error) {
	req, err := transportapi.NewDeparturesRequest(from)
	if err != nil {
		return nil, err
	}
	res, err := fetch(req)
	if err != nil {
		return nil, err
	}
	data, err := transportapi.ParseResponse(res)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func merge(l *ldb.GetDepartureBoardResponse, t *transportapi.Response) []*departure {
	deps := make([]*departure, len(l.GetStationBoardResult.TrainServices.Service))

	for i := range(deps) {
		s := l.GetStationBoardResult.TrainServices.Service[i]
		deps[i] = &departure{
			DestinationCode: s.Destination.Location.CRS,
			DestinationName: s.Destination.Location.LocationName,
			ScheduledDeparture: s.STD,
			EstimatedDeparture: s.ETD,
			EstimatedPlatform: s.Platform,
		}
	}

	// n^2, woohooo!
	for _, td := range(t.Departures.All) {
		for _, d := range(deps) {
			if td.DestinationName == d.DestinationName && td.AimedDepartureTime == d.ScheduledDeparture {
				d.ScheduledPlatform = td.Platform
			}
		}
	}

	return deps
}

func getMergedDepartures(from string, to string) *response {
	ldbDeps, ldbErr := fetchLiveDepartures(from, to)
	tapiDeps, tapiErr := fetchTransportAPI(from)

	r := &response{
		OriginCode: from,
		DestinationCode: to,
	}
	if ldbErr == nil && tapiErr == nil {
		r.Departures = merge(ldbDeps, tapiDeps)
	} else {
		if ldbErr != nil {
			r.LdbError = ldbErr.Error()
		}
		if tapiErr != nil {
			r.TransportapiError = tapiErr.Error()
		}
	}

	return r
}

func departures(w http.ResponseWriter, r *http.Request) {
	parts := path.FindStringSubmatch(r.URL.Path)
	if len(parts) != 3 {
		http.Error(w, fmt.Sprintf("Bad request %v", parts), 400)
		return
	}

	d := getMergedDepartures(parts[1], parts[2])

	if err := template.T.ExecuteTemplate(w, "trains/dep", d); err != nil {
		http.Error(w, err.Error(), 500)
	}
}

func init() {
	http.HandleFunc("/trains/dep/", departures)
}
