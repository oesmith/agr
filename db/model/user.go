package model

import (
	"bytes"
	"encoding/gob"
)

type User struct {
	Username string
	EncryptedPassword []byte
}

func (u *User) Encode() ([]byte, error) {
	var buf bytes.Buffer
	enc := gob.NewEncoder(&buf)
	if err := enc.Encode(u); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func DecodeUser(b []byte) (*User, error) {
	var user *User
	buf := bytes.NewBuffer(b)
	dec := gob.NewDecoder(buf)
	err := dec.Decode(&user)
	return user, err
}
