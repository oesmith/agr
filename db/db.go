package db

import (
	"errors"

	"github.com/oesmith/agr/db/model"
)

var (
	NoSuchUserError = errors.New("No such user")
	UserAlreadyExistsError = errors.New("User already exists")
)

type DB interface {
	Close() error
	CreateUser(user *model.User) error
	GetUser(username string) (*model.User, error)
}
