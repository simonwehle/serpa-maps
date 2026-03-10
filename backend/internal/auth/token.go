package auth

import (
	"fmt"
	"serpa-maps/internal/models"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func GenerateAccessToken(jwtKey []byte, userID uuid.UUID) (string, error) {
	claims := jwt.MapClaims{
		"sub": userID.String(),
		"exp": time.Now().Add(time.Minute * 15).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtKey)
}

func generateRefreshToken(refreshKey []byte, userID uuid.UUID) (string, models.RefreshToken, error) {
	jti := uuid.New()
	now := time.Now()
	exp := now.Add(30 * 24 * time.Hour)

	claims := jwt.MapClaims{
		"sub":  userID.String(),
		"jti":  jti.String(),
		"exp":  exp.Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	signed, err := token.SignedString(refreshKey)
	if err != nil {
		return "", models.RefreshToken{}, err
	}

	persistentToken := models.RefreshToken{
		Jti: jti,
		UserID: userID,
		CreatedAt: now,
		ExpiresAt: exp,
		Revoked: false,
	}

	return signed, persistentToken, nil
}

func persistRefreshToken(persistentToken models.RefreshToken, db *gorm.DB) error {
	result := db.Create(&persistentToken)
	return result.Error
}

func GenerateAndPersistRefreshToken(refreshKey []byte, userID uuid.UUID, db *gorm.DB) (string, error) {
	signedToken, persistentToken, err := generateRefreshToken(refreshKey, userID)
	if err != nil {
		return "", err
	}

	if err := persistRefreshToken(persistentToken, db); err != nil {
		return "", err
	}

	return signedToken, nil
}

func ValidateToken(jwtKey []byte, tokenString string) (*jwt.Token, error) {
	return jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return jwtKey, nil
	})
}

func ValidateRefreshToken(refreshKey []byte, tokenString string, db *gorm.DB) (*models.RefreshToken, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return refreshKey, nil
	})
	if err != nil {
		return nil, fmt.Errorf("invalid token: %w", err)
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return nil, fmt.Errorf("invalid token claims")
	}

	jtiStr, ok := claims["jti"].(string)
	if !ok {
		return nil, fmt.Errorf("missing jti claim")
	}

	jti, err := uuid.Parse(jtiStr)
	if err != nil {
		return nil, fmt.Errorf("invalid jti format: %w", err)
	}

	var refreshToken models.RefreshToken
	if err := db.Where("jti = ?", jti).First(&refreshToken).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, fmt.Errorf("token not found")
		}
		return nil, fmt.Errorf("database error: %w", err)
	}

	if refreshToken.Revoked {
		return nil, fmt.Errorf("token has been revoked")
	}

	if time.Now().After(refreshToken.ExpiresAt) {
		return nil, fmt.Errorf("token has expired")
	}

	return &refreshToken, nil
}

func RevokeRefreshToken(jti uuid.UUID, db *gorm.DB) error {
	result := db.Model(&models.RefreshToken{}).Where("jti = ?", jti).Update("revoked", true)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("token not found")
	}
	return nil
}