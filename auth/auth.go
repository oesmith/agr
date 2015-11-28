package auth

import (
	"net/http"
	"time"

	"github.com/gorilla/securecookie"
	"github.com/oesmith/agr/db"
)

import "flag"

const (
	PathPrefix = "/auth/"
	authCookie = "auth"
	cookieExpiry = time.Hour * 24 * 60 // 60-day cookie validity
)

var (
	cookieKeyFlag = flag.String("cookie_key", "", "Key for encrypted auth cookies")
	passwordSaltFlag = flag.String("password_salt", "", "Salt used for password auth")
)

type Auth struct {
	db db.DB
	passwordSalt []byte
	secureCookie *securecookie.SecureCookie
}

func New(db db.DB) *Auth {
	return newAuthWithKeys(db, []byte(*cookieKeyFlag), []byte(*passwordSaltFlag))
}

func (a *Auth) Handler() http.Handler {
	mux := http.NewServeMux()
	mux.Handle(PathPrefix + "login", &loginHandler{a})
	mux.Handle(PathPrefix + "logout", &logoutHandler{a})
	return mux
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
func (a *Auth) VerifyCookie(c *http.Cookie) (string, error) {
	value := make(map[string]string)
	if err := a.secureCookie.Decode(authCookie, c.Value, &value); err != nil {
		return "", err
	}
	return value["username"], nil
}

func newAuthWithKeys(db db.DB, cookieKey []byte, passwordSalt []byte) *Auth {
	if len(cookieKey) != 64 {
		panic("Cookie key should be 64 bytes long")
	}
	return &Auth{
		db: db,
		passwordSalt: passwordSalt,
		secureCookie: securecookie.New(cookieKey, nil),
	}
}
