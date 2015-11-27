package auth

import (
	"net/http"
)

type logoutHandler struct {
	auth *Auth
}

func (l *logoutHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// TODO(ollysmith): implement.
}
