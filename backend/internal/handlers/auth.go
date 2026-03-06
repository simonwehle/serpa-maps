package handlers

import (
	"net/http"
	"serpa-maps/internal/auth"
	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func Login(db *gorm.DB, jwtKeys models.JwtKeys) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req models.UserRequest

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Email and password are required"})
			return
		}

		var user models.User

		if err := db.Where("email = ?", req.Email).First(&user).Error; err != nil {
			if err == gorm.ErrRecordNotFound {
				c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
				return
			}
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
			return
		}

		accessToken, err := auth.GenerateAccessToken(jwtKeys.AccessKey, user.UserID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate access token"})
			return
		}

		refreshToken, err := auth.GenerateAndPersistRefreshToken(jwtKeys.RefreshKey, user.UserID, db)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate and persist refresh token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"access_token":  accessToken,
			"refresh_token": refreshToken,
			"user_id":       user.UserID,
			"email":         user.Email,
			"username":      user.Username,
		})
	}
}

func Register(db *gorm.DB, jwtKeys models.JwtKeys) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req models.RegisterRequest

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		var existingUser models.User
		if err := db.Where("email = ?", req.Email).First(&existingUser).Error; err == nil {
			c.JSON(http.StatusConflict, gin.H{"error": "Email already registered"})
			return
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}

		user := models.User{
			Email:    req.Email,
			Username: req.Username,
			Password: string(hashedPassword),
		}

		if err := db.Create(&user).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user", "details": err.Error()})
			return
		}

		accessToken, err := auth.GenerateAccessToken(jwtKeys.AccessKey, user.UserID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
			return
		}

		refreshToken, err := auth.GenerateAndPersistRefreshToken(jwtKeys.RefreshKey, user.UserID, db)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate and persist refresh token"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{
			"access_token":  accessToken,
			"refresh_token": refreshToken,
			"user_id":       user.UserID,
			"email":         user.Email,
			"username":      user.Username,
		})
	}
}

func Refresh(db *gorm.DB, jwtKeys models.JwtKeys) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req struct {
			RefreshToken string `json:"refresh_token" binding:"required"`
		}

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Refresh token is required"})
			return
		}

		refreshToken, err := auth.ValidateRefreshToken(jwtKeys.RefreshKey, req.RefreshToken, db)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired refresh token"})
			return
		}

		accessToken, err := auth.GenerateAccessToken(jwtKeys.AccessKey, refreshToken.UserID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate access token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"access_token": accessToken,
		})
	}
}

func Logout(db *gorm.DB, refreshKey []byte) gin.HandlerFunc {
	return func(c *gin.Context) {
		userIDValue, exists := c.Get("user_id")
		if !exists {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
			return
		}

		userIDStr, ok := userIDValue.(string)
		if !ok {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID format"})
			return
		}

		var req struct {
			RefreshToken string `json:"refresh_token" binding:"required"`
		}

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Refresh token is required"})
			return
		}

		refreshToken, err := auth.ValidateRefreshToken(refreshKey, req.RefreshToken, db)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired refresh token"})
			return
		}

		if refreshToken.UserID.String() != userIDStr {
			c.JSON(http.StatusForbidden, gin.H{"error": "Cannot revoke token belonging to another user"})
			return
		}

		if err := auth.RevokeRefreshToken(refreshToken.Jti, db); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to revoke token"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"message": "Successfully logged out",
		})
	}
}