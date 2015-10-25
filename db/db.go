package db

import (
	"github.com/boltdb/bolt"
)

type DB struct {
	*bolt.DB
}

func Open(path string) (*DB, error) {
	db, err := bolt.Open(path, 0600, nil)
	if err != nil {
		return nil, err
	}
	return &DB{db}, nil
}
