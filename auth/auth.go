package auth

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gorilla/context"
	"github.com/gorilla/securecookie"
	"github.com/oesmith/agr/db"
	"github.com/oesmith/agr/db/model"
)

import "flag"

const (
	authCookie = "auth"
	cookieExpiry = time.Hour * 24 * 60 // 60-day cookie validity
	userKey = "oesmith/agr/user"
)

var (
	cookieKeyFlag = flag.String("cookie_key", "", "Key for encrypted auth cookies")
	passwordSaltFlag = flag.String("password_salt", "", "Salt used for password auth")
)

type Auth struct {
	PingHandler http.Handler

	db db.DB
	passwordSalt []byte
	secureCookie *securecookie.SecureCookie
}

func New(db db.DB) *Auth {
	return newAuthWithKeys(db, []byte(*cookieKeyFlag), []byte(*passwordSaltFlag))
}

func (a *Auth) AuthCookie(u string) (*http.Cookie, error) {
	value := map[string]string{
		"username": u,
	}
	encoded, err := a.secureCookie.Encode(authCookie, value)
	if err != nil {
		return nil, err
	}
	ret := &http.Cookie{
		Name: authCookie,
		Value: encoded,
		Path: "/",
		HttpOnly: true,
		Expires: time.Now().Add(cookieExpiry),
	}
	return ret, nil
}

// VerifyCookie checks the given cookie is valid and returns the username
// encoded within.
func (a *Auth) VerifyCookie(c *http.Cookie) (*model.User, error) {
	value := make(map[string]string)
	if err := a.secureCookie.Decode(authCookie, c.Value, &value); err != nil {
		return nil, err
	}
	u, err := a.db.GetUser(value["username"])
	if err != nil {
		return nil, err
	}
	return u, nil
}

func (a * Auth) RequireUser(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if c, err := r.Cookie(authCookie); err == nil && c != nil {
			if u, err := a.VerifyCookie(c); err == nil {
				context.Set(r, userKey, u)
				h.ServeHTTP(w, r)
				return
			}
		}
		http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
	})
}

func (a *Auth) pingHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "OK")
}

func newAuthWithKeys(db db.DB, cookieKey []byte, passwordSalt []byte) *Auth {
	if len(cookieKey) != 64 {
		panic("Cookie key should be 64 bytes long")
	}
	a := &Auth{
		db: db,
		passwordSalt: passwordSalt,
		secureCookie: securecookie.New(cookieKey, nil),
	}
	a.PingHandler = a.RequireUser(http.HandlerFunc(a.pingHandler))
	return a
}
