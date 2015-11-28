package db

import (
	"io/ioutil"
	"os"
	"reflect"
	"testing"

	"github.com/oesmith/agr/db/model"
)

var db DB

func TestMain(m *testing.M) {
	f, err := ioutil.TempFile("", "dbtest")
	if err != nil {
		panic(err)
	}
	p := f.Name()
	f.Close()
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
