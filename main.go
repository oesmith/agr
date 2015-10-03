package main

import (
	"flag"
	"log"
	"net/http"

	_ "github.com/oesmith/agr/trains"
)

func main() {
	flag.Parse()
	log.Print("Listening on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
