package auth

import (
	"testing"

	"github.com/oesmith/agr/db"
	dbt "github.com/oesmith/agr/db/testing"
)

func TestAuthoriseUser_UserNotFound(t *testing.T) {
	auth := NewAuth(dbt.NewFakeDB())
	_, err := auth.AuthoriseUser("missinguser", "password")
	if err != db.NoSuchUserError {
		t.Fatal("Expected NoSuchUserError, got", err)
	}
}

func TestAuthoriseUser_InvalidPassword(t *testing.T) {
	auth, err := setupUser("invalidpassworduser", "password")
	if err != nil {
		t.Fatal(err)
	}
	_, err = auth.AuthoriseUser("invalidpassworduser", "invalidpassword")
	if err != InvalidPasswordError {
		t.Fatal("Expected InvalidPasswordError, got", err)
	}
}

func TestAuthoriseUser_ReturnsUser(t *testing.T) {
	auth, err := setupUser("username", "password")
	if err != nil {
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
