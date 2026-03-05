package auth

import (
	"fmt"
	"serpa-maps/internal/models"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

func GenerateAccessToken(jwtKey []byte, userID uuid.UUID) (string, error) {
	now := time.Now()

	claims := jwt.MapClaims{
		"sub": userID.String(),
		"jti": uuid.NewString(),
		"type": "access",
		"iat": now.Unix(),
		"exp": now.Add(time.Minute * 15).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtKey)
}

func GenerateRefreshToken(refreshKey []byte, userID uuid.UUID) (string, models.Token, error) {
	persistentToken := models.Token{}
	jti := uuid.New()
	now := time.Now()
	exp := now.Add(30 * 24 * time.Hour)

	claims := jwt.MapClaims{
		"sub":  userID.String(),
		"jti":  jti.String(),
		"type": "refresh",
		"iat":  now.Unix(),
		"exp":  exp.Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	signed, err := token.SignedString(refreshKey)
	if err != nil {
		return "", persistentToken, err
	}

	persistentToken = models.Token{
		Jti: jti,
		UserID: userID,
		CreatedAt: now,
		ExpiresAt: exp,
		Revoked: false,
	}

	return signed, persistentToken, nil
}

func ValidateToken(jwtKey []byte, tokenString string) (*jwt.Token, error) {
	return jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return jwtKey, nil
	})
}