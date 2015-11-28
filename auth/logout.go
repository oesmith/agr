package auth

import (
	"fmt"
	"net/http"
	"time"
)

func (a *Auth) LogoutHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
		return
	}
	c := &http.Cookie{
		Name: authCookie,
		Value: "",
		HttpOnly: true,
		Path: "/",
		Expires: time.Unix(1, 0),
	}
	http.SetCookie(w, c)
	fmt.Fprint(w, "OK")
}
