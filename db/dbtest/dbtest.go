package dbtest

import (
	"github.com/oesmith/agr/db"
	"github.com/oesmith/agr/db/model"
)

type fakeDB struct {
	Users map[string]*model.User
}

func NewFakeDB() db.DB {
	return &fakeDB{
		Users: make(map[string]*model.User),
	}
}

func (f *fakeDB) Close() error {
	return nil
}

func (f *fakeDB) CreateUser(u *model.User) error {
	if _, ok := f.Users[u.Username]; ok {
		return db.UserAlreadyExistsError
	}
	f.Users[u.Username] = u
	return nil
}

func (f *fakeDB) GetUser(u string) (*model.User, error) {
	user, ok := f.Users[u]
	if !ok {
		return nil, db.NoSuchUserError
	}
	return user, nil
}
