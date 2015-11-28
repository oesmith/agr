package auth

import (
	"net/http"
	"net/http/httptest"
	"testing"

	dbt "github.com/oesmith/agr/db/testing"
)

func TestLogout_NoGet(t *testing.T) {
	auth := NewAuth(dbt.NewFakeDB())
	r, err := http.NewRequest("GET", "/auth/logout", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.Handler().ServeHTTP(w, r)
	if w.Code != http.StatusBadRequest {
		t.Error("Expected StatusBadRequest, got", w.Code)
	}
	if w.Header().Get(authCookie) != "" {
		t.Error("Expected no auth cookie, got", w.Header())
	}
}

func TestLogout(t *testing.T) {
	auth := NewAuth(dbt.NewFakeDB())
	r, err := http.NewRequest("POST", "/auth/logout", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.Handler().ServeHTTP(w, r)
	if w.Code != http.StatusOK {
		t.Error("Expected StatusOK, got", w.Code)
	}
	cookieHeader := w.Header().Get("Set-Cookie")
	if cookieHeader != "auth=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 UTC; HttpOnly" {
		t.Error("Expected expired auth cookie, got", cookieHeader)
	}
}
