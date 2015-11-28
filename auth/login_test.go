package auth

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestLogin_NoGet(t *testing.T) {
	auth, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	r, err := http.NewRequest("GET", "", nil)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.LoginHandler(w, r)
	if w.Code != http.StatusBadRequest {
		t.Error("Expected StatusBadRequest, got", w.Code)
	}
	if w.Header().Get(authCookie) != "" {
		t.Error("Expected no auth cookie, got", w.Header())
	}
}

func TestLogin_Invalid(t *testing.T) {
	auth, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	body := strings.NewReader("username=username&password=foo")
	r, err := http.NewRequest("POST", "", body)
	if err != nil {
		t.Fatal(err)
	}
	w := httptest.NewRecorder()
	auth.LoginHandler(w, r)
	if w.Code != http.StatusUnauthorized {
		t.Error("Expected StatusUnauthorized, got", w.Code)
	}
	if w.Header().Get("Set-Cookie") != "" {
		t.Error("Expected no auth cookie, got", w.Header())
	}
}

func TestLogin_Success(t *testing.T) {
	auth, err := setupUser("username", "password")
	if err != nil {
		t.Fatal(err)
	}
	body := strings.NewReader("username=username&password=password")
	r, err := http.NewRequest("POST", "", body)
	if err != nil {
		t.Fatal(err)
	}
	r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	w := httptest.NewRecorder()
	auth.LoginHandler(w, r)
	if w.Code != http.StatusOK {
		t.Error("Expected StatusOK, got", w.Code)
	}
	if w.Header().Get("Set-Cookie") == "" {
		t.Error("Expected auth cookie, got none")
	}
}
