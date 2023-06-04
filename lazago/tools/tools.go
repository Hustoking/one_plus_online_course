package tools

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"strings"
	"unicode"
)

func UpperCase(input string) (output string) {
	output = strings.Map(func(r rune) rune {
		if unicode.IsLower(r) {
			return unicode.ToUpper(r)
		}
		return r
	}, input)
	return
}

type MyClaims struct {
	jwt.StandardClaims
	UserAccount string `json:"userAccount"`
}

func ParseJwt2Account(tokenString string) (account string, err error) {
	mySigningKey := []byte("ae86")
	token, err := jwt.ParseWithClaims(tokenString, &MyClaims{}, func(token *jwt.Token) (interface{}, error) {
		return mySigningKey, nil
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	account = token.Claims.(*MyClaims).UserAccount
	return
}
