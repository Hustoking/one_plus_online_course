package test

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"testing"
	"time"
)

type MyClaims struct {
	jwt.StandardClaims
	UserAccount string `json:"userAccount"`
}

func TestGenJwt(t *testing.T) {
	// 加密 key
	mySigningKey := []byte("ae86")

	myClaim := MyClaims{
		UserAccount: "hsk",
		StandardClaims: jwt.StandardClaims{
			NotBefore: time.Now().Unix() - 60,    // 一分钟前
			ExpiresAt: time.Now().Unix() + 60*60, // 一小时后
			Issuer:    "manager",
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, myClaim)
	fmt.Println("token: \n", token)

	// 加密
	signedString, err := token.SignedString(mySigningKey)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("signedString: \n", signedString)
}

func TestParseJwt(t *testing.T) {
	mySigningKey := []byte("ae86")
	// jwt
	myJwt := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2ODA2ODczMjYsImlzcyI6Im1hbmFnZXIiLCJuYmYiOjE2ODA2ODM2NjYsInVzZXJBY2NvdW50IjoiaHNrIn0.C_3-TtLz-SPfOUiOSKYKzXp8s-1P6Askc29d6bKBQVU"
	token, err := jwt.ParseWithClaims(myJwt, &MyClaims{}, func(token *jwt.Token) (interface{}, error) {
		return mySigningKey, nil
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("token: \n", token.Claims.(*MyClaims).UserAccount)
}
