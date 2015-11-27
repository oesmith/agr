package auth

import (
	"strings"
	"testing"

	dbt "github.com/oesmith/agr/db/testing"
)

func TestAuthCookie_VerifyCookie(t *testing.T) {
	d := dbt.NewFakeDB()
	a := newAuthWithKeys(d, []byte(strings.Repeat("c", 64)), []byte(strings.Repeat("p", 64)))
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
