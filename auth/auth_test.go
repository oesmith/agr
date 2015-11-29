package auth

import (
	"crypto/rand"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/oesmith/agr/db"
	"github.com/oesmith/agr/db/model"
	"github.com/oesmith/agr/db/dbtest"
)

func TestAuthCookie_VerifyCookie(t *testing.T) {
	a, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
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
	if u.Username != "username" {
		t.Fatal("Expected 'username', got", u)
	}
}

func TestRequireUser_NoCookie(t *testing.T) {
	a, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	called := false
	h := a.RequireUser(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		called = true
	}))
	r, err := http.NewRequest("GET", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != http.StatusUnauthorized {
		t.Error("Expected StatusUnauthorized, got", w.Code)
	}
	if called == true {
		t.Error("Handler was unexpectedly called")
	}
}

func TestRequireUser_InvalidUser(t *testing.T) {
	a, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	called := false
	h := a.RequireUser(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		called = true
	}))
	r, err := http.NewRequest("GET", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	c, err := a.AuthCookie("wronguser")
	if err != nil {
		t.Fatal(err)
	}
	r.Header.Set("Cookie", c.Name + "=" + c.Value)
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != http.StatusUnauthorized {
		t.Error("Expected StatusUnauthorized, got", w.Code)
	}
	if called == true {
		t.Error("Handler was unexpectedly called")
	}
}

func TestRequireUser_ValidUser(t *testing.T) {
	a, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	called := false
	h := a.RequireUser(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		called = true
	}))
	r, err := http.NewRequest("GET", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	c, err := a.AuthCookie("username")
	if err != nil {
		t.Fatal(err)
	}
	r.Header.Set("Cookie", c.Name + "=" + c.Value)
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	if w.Code != http.StatusOK {
		t.Error("Expected StatusOK, got", w.Code)
	}
	if called == false {
		t.Error("Handler was not called")
	}
}

// setupUser creates a new database and auth instance with the given user
// configured.
func setupUser(u, p string) (*Auth, error) {
	d := dbtest.NewFakeDB()
	auth := setupAuth(d)
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

func setupAuth(db db.DB) *Auth {
	return newAuthWithKeys(db, keyData(), keyData())
}

// keyData uses crypto/rand to generate a random 64-byte key.
func keyData() []byte {
	b := make([]byte, 64)
	if _, err := rand.Read(b); err != nil {
		panic(err)
	}
	return b
}
