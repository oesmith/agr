package auth

import (
	"testing"

	"github.com/oesmith/agr/db/model"
	"github.com/oesmith/agr/db/dbtest"
)

func TestAuthCookie_VerifyCookie(t *testing.T) {
	a := NewAuth(dbtest.NewFakeDB())
	c, err := a.AuthCookie("username")
	if err != nil {
		t.Fatal(err)
	}
	if c.HttpOnly != true {
		t.Error("Expected HttpOnly, got", c)
	}
	if c.Path != "/" {
		t.Error("Expected Path='/', got", c)
	}
	if c.Name != authCookie {
		t.Error("Expected Name='" + authCookie + "', got", c)
	}
	u, err := a.VerifyCookie(c)
	if err != nil {
		t.Fatal(err)
	}
	if u != "username" {
		t.Fatal("Expected 'username', got", u)
	}
}

// setupUser creates a new database and auth instance with the given user
// configured.
func setupUser(u, p string) (*Auth, error) {
	d := dbtest.NewFakeDB()
	auth := NewAuth(d)
	pw, err := auth.EncryptPassword(p)
	if err != nil {
		return nil, err
	}
	err = d.CreateUser(&model.User{u, pw})
	if err != nil {
		return nil, err
	}
	return auth, nil
}
