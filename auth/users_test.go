package auth

import (
	"net/http"
	"strings"
	"testing"

	"github.com/oesmith/agr/db"
	"github.com/oesmith/agr/db/model"
	dbt "github.com/oesmith/agr/db/testing"
)

var (
	auth *Auth
	d db.DB
	mux *http.ServeMux
	testCookieKey = []byte(strings.Repeat("c", 64))
	testPasswordSalt = []byte("passwordSalt")
)

func TestMain(m *testing.M) {
	d = dbt.NewFakeDB()
	mux = http.NewServeMux()
	auth = newAuthWithKeys(d, testCookieKey, testPasswordSalt)
	m.Run()
}

func TestAuthoriseUser_UserNotFound(t *testing.T) {
	_, err := auth.AuthoriseUser("missinguser", "password")
	if err != db.NoSuchUserError {
		t.Fatal("Expected NoSuchUserError, got", err)
	}
}

func TestAuthoriseUser_InvalidPassword(t *testing.T) {
	if err := setupUser("invalidpassworduser", "password"); err != nil {
		t.Fatal(err)
	}
	_, err := auth.AuthoriseUser("invalidpassworduser", "invalidpassword")
	if err != InvalidPasswordError {
		t.Fatal("Expected InvalidPasswordError, got", err)
	}
}

func TestAuthoriseUser_ReturnsUser(t *testing.T) {
	if err := setupUser("username", "password"); err != nil {
		t.Fatal(err)
	}
	user, err := auth.AuthoriseUser("username", "password")
	if err != nil {
		t.Fatal("Expected InvalidPasswordError, got", err)
	}
	if user == nil || user.Username != "username" {
		t.Fatal("Expected 'username', got", user)
	}
}

func setupUser(u, p string) error {
	pw, err := auth.EncryptPassword(p)
	if err != nil {
		return err
	}
	err = d.CreateUser(&model.User{u, pw})
	if err != nil {
		return err
	}
	return nil
}
