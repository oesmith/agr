package model

import (
	"reflect"
	"testing"
)

func TestEncodeDecode(t *testing.T) {
	u := &User{
		Username: "example",
		EncryptedPassword: []byte("encrypted_password"),
	}
	b, err := u.Encode()
	if err != nil {
		t.Fatal("Encoding failed", err)
	}
	u2, err := DecodeUser(b)
	if err != nil {
		t.Fatal("Decoding failed", err)
	}
	if !reflect.DeepEqual(u, u2) {
		t.Fatal("Decoded user does not match encoded user. ", u, u2)
	}
}
