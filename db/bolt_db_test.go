package db

import (
	"os"
	"reflect"
	"testing"

	"github.com/oesmith/agr/db/model"
	dbt "github.com/oesmith/agr/db/testing"
)

var db DB

func TestMain(m *testing.M) {
	p := dbt.TestDBPath()
	defer os.Remove(p)
	db = Must(Open(p))
	defer db.Close()
	m.Run()
}

func TestGetUser_NoSuchUser(t *testing.T) {
	_, err := db.GetUser("nosuchuser")
	if err != NoSuchUserError {
		t.Fatal("Expected NoSuchUserError, got", err)
	}
}

func TestCreateUser_GetUser(t *testing.T) {
	u := &model.User{"createduser", []byte("encrypted_password")}
	err := db.CreateUser(u)
	if err != nil {
		t.Fatal("Failed to create user", err)
	}
	u2, err := db.GetUser("createduser")
	if err != nil {
		t.Fatal("Failed to create user", err)
	}
	if !reflect.DeepEqual(u, u2) {
		t.Fatal("GetUser: expected", u, "got", u2)
	}
}

func TestCreateUser_UserAlreadyExists(t *testing.T) {
	u := &model.User{"duplicateuser", []byte("encrypted_password")}
	err := db.CreateUser(u)
	if err != nil {
		t.Fatal("Failed to create user", err)
	}
	err = db.CreateUser(u)
	if err != UserAlreadyExistsError {
		t.Fatal("Expected UserAlreadyExistsError, got", err)
	}
}
