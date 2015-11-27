package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/oesmith/agr/auth"
	"github.com/oesmith/agr/db"
	_ "github.com/oesmith/agr/trains"
)

var (
	dbPath = flag.String("database_path", "data.db", "Path to boltdb database")
)

func main() {
	flag.Parse()
	d, err := db.Open(*dbPath)
	if err != nil {
		log.Fatal("Unable to open database:", err.Error())
	}
	a := auth.NewAuth(d)
	http.Handle(auth.PathPrefix, a.Handler())
	log.Print("Listening on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
