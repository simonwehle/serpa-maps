package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"

	"serpa-maps/internal/auth"
)

func AuthMiddleware(jwtKey []byte) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
   			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header missing or malformed"})
   			c.Abort()
   			return
  		}
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
  		token, err := auth.ValidateToken(jwtKey, tokenString)

  		if err != nil || !token.Valid {
   			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
   			c.Abort()
   			return
  		}

  		claims := token.Claims.(jwt.MapClaims)
  		c.Set("user_id", claims["user_id"])
  		c.Next()
	}
}