package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/gorilla/mux"
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
	a := auth.New(d)
	r := mux.NewRouter()
	r.HandleFunc("/api/v1/auth/login", a.LoginHandler)
	r.HandleFunc("/api/v1/auth/logout", a.LogoutHandler)
	r.Handle("/api/v1/auth/ping", a.PingHandler)
	http.Handle("/", r)
	log.Print("Listening on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
