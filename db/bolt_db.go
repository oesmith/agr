package db

import (
	"github.com/boltdb/bolt"

	"github.com/oesmith/agr/db/model"
)

var (
	usersBucket = []byte("users")

	buckets = [][]byte{usersBucket}
)

type boltDB struct {
	*bolt.DB
}

func Open(path string) (DB, error) {
	db, err := bolt.Open(path, 0600, nil)
	if err != nil {
		return nil, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		for _, name := range(buckets) {
			if _, err := tx.CreateBucketIfNotExists(name); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &boltDB{db}, nil
}

func Must(db DB, err error) DB {
	if err != nil {
		panic(err)
	}
	return db
}

func (db *boltDB) GetUser(username string) (*model.User, error) {
	var user *model.User
	err := db.View(func(tx *bolt.Tx) error {
		b := bucketOrPanic(tx, usersBucket)
		u := b.Get([]byte(username))
		if u == nil {
			return NoSuchUserError
		}
		var err error
		user, err = model.DecodeUser(u)
		return err
	})
	return user, err
}

func (db *boltDB) CreateUser(user *model.User) error {
	return db.Update(func(tx *bolt.Tx) error {
		b := bucketOrPanic(tx, usersBucket)
		k := []byte(user.Username)
		if b.Get(k) != nil {
			return UserAlreadyExistsError
		}
		data, err := user.Encode()
		if err != nil {
			return err
		}
		return b.Put(k, data)
	})
}

func bucketOrPanic(tx *bolt.Tx, name []byte) *bolt.Bucket {
	b := tx.Bucket(name)
	if b == nil {
		panic("Missing bucket")
	}
	return b
}
