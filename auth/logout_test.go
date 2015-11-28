package auth

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/oesmith/agr/db/dbtest"
)

func TestLogout_NoGet(t *testing.T) {
	auth := setupAuth(dbtest.NewFakeDB())
	r, err := http.NewRequest("GET", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.LogoutHandler(w, r)
	if w.Code != http.StatusBadRequest {
		t.Error("Expected StatusBadRequest, got", w.Code)
	}
	if w.Header().Get(authCookie) != "" {
		t.Error("Expected no auth cookie, got", w.Header())
	}
}

func TestLogout(t *testing.T) {
	auth := setupAuth(dbtest.NewFakeDB())
	r, err := http.NewRequest("POST", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.LogoutHandler(w, r)
	if w.Code != http.StatusOK {
		t.Error("Expected StatusOK, got", w.Code)
	}
	res := http.Response{Header: w.Header()}
	c := res.Cookies()[0]
	if c.Name != authCookie ||
			c.Value != "" ||
			c.Path != "/" ||
			!c.Expires.Before(time.Now()) ||
			!c.HttpOnly {
		t.Error("Expected expired auth cookie, got", c)
	}
}
