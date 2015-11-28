package auth

import (
	"net/http"
	"fmt"
)

type loginHandler struct {
	auth *Auth
}

func (l *loginHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}
	username := r.PostFormValue("username")
	password := r.PostFormValue("password")
	user, err := l.auth.AuthoriseUser(username, password)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
		return
	}
	c, err := l.auth.AuthCookie(user.Username)
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	http.SetCookie(w, c)
	fmt.Fprint(w, "OK")
}
