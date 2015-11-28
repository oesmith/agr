package main

import (
	"flag"
	"log"

	"github.com/oesmith/agr/auth"
	"github.com/oesmith/agr/db"
	"github.com/oesmith/agr/db/model"
)

var (
	commands = map[string]func() {
		"useradd": userAdd,
	}

	command = flag.String("c", "", "command")
	databasePath = flag.String("db", "", "database path")
	username = flag.String("u", "", "username")
	password = flag.String("p", "", "password")

	a *auth.Auth
	d db.DB
)

func userAdd() {
	if *username == "" || *password == "" {
		log.Fatal("ERROR: -u and -p required")
	}
	pw, err := a.EncryptPassword(*password)
	if err != nil {
		log.Fatal("ERROR:", err)
	}
	u := &model.User{
		Username: *username,
		EncryptedPassword: pw,
	}
	err = d.CreateUser(u)
	if err != nil {
		log.Fatal("ERROR:", err)
	}
}

func main() {
	var err error
	flag.Parse()
	if *command == "" {
		log.Fatal("ERROR: -c required")
	}
	if *databasePath == "" {
		log.Fatal("ERROR: -db required")
	}
	d, err = db.Open(*databasePath)
	if err != nil {
		log.Fatal("ERROR:", err)
	}
	a = auth.New(d)
	fn, ok := commands[*command]
	if !ok {
		log.Fatal("ERROR: Invalid command:", *command)
	}
	fn()
}
