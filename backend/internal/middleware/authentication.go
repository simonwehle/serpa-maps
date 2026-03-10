package middleware

import (
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"

	"serpa-maps/internal/auth"
)

func AuthMiddleware(jwtKey []byte) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		
		if authHeader == "" {
			c.Header("WWW-Authenticate", "Bearer realm=\"serpa-maps\"")
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}
		
		if !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
				"error": "invalid_request",
				"message": "Authorization header must use Bearer scheme",
			})
			return
		}
		
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		token, err := auth.ValidateToken(jwtKey, tokenString)

		if err != nil {
			c.Header("WWW-Authenticate", "Bearer realm=\"serpa-maps\"")
			
			message := "Token is invalid"
			fmt.Printf("Token validation error: %v\n", err)
			if errors.Is(err, jwt.ErrTokenExpired) {
				message = "Token has expired"
			}
			
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error": "invalid_token",
				"message": message,
			})
			return
		}
		
		if !token.Valid {
			c.Header("WWW-Authenticate", "Bearer realm=\"serpa-maps\"")
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
				"error": "invalid_token",
				"message": "Token is invalid",
			})
			return
		}

		claims := token.Claims.(jwt.MapClaims)
		c.Set("user_id", claims["sub"])
		c.Next()
	}
}