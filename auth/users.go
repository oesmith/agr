package auth

import (
	"crypto/subtle"
	"errors"

	"golang.org/x/crypto/scrypt"

	"github.com/oesmith/agr/db/model"
)

var (
	InvalidPasswordError = errors.New("Invalid password")
)

func (a *Auth) AuthoriseUser(username string, password string) (*model.User, error) {
	u, err := a.db.GetUser(username)
	if err != nil {
		return nil, err
	}
	pw, err := a.EncryptPassword(password)
	if err != nil {
		return nil, err
	}
	if 1 != subtle.ConstantTimeCompare(u.EncryptedPassword, pw) {
		return nil, InvalidPasswordError
	}
	return u, nil
}

func (a *Auth) EncryptPassword(password string) ([]byte, error) {
	return scrypt.Key([]byte(password), a.passwordSalt, 16384, 8, 1, 32)
}
