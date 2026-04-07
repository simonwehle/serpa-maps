package handlers

import (
	"fmt"
	"math"
	"net/http"
	"serpa-maps/internal/models"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func buildAssetURL(assetURL, assetFilename string) string {
    return fmt.Sprintf("%s/%s", strings.TrimRight(assetURL, "/"), strings.TrimPrefix(assetFilename, "/"))
}

func validatePlaceInput(name string, latitude, longitude float64) error {
	if strings.TrimSpace(name) == "" {
		return fmt.Errorf("name is required")
	}
	if len(name) > 255 {
		return fmt.Errorf("name too long (max 255 characters)")
	}
	if latitude < -90 || latitude > 90 {
		return fmt.Errorf("invalid latitude (must be between -90 and 90)")
	}
	if longitude < -180 || longitude > 180 {
		return fmt.Errorf("invalid longitude (must be between -180 and 180)")
	}
	return nil
}

func round6(v float64) float64 {
	return math.Round(v*1e6) / 1e6
}

func getSharedPlaceIDs(db *gorm.DB, userID uuid.UUID) []uuid.UUID {
	var memberships []models.GroupMember
	db.Where("user_id = ?", userID).Find(&memberships)
	if len(memberships) == 0 {
		return nil
	}

	groupIDs := make([]uuid.UUID, len(memberships))
	for i, m := range memberships {
		groupIDs[i] = m.GroupID
	}

	var shares []models.PlaceShare
	db.Where("group_id IN ?", groupIDs).Find(&shares)
	if len(shares) == 0 {
		return nil
	}

	placeIDs := make([]uuid.UUID, len(shares))
	for i, s := range shares {
		placeIDs[i] = s.PlaceID
	}
	return placeIDs
}

func parseUserID(c *gin.Context) (uuid.UUID, bool) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return uuid.Nil, false
	}
	parsed, err := uuid.Parse(fmt.Sprintf("%v", userID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID format"})
		return uuid.Nil, false
	}
	return parsed, true
}

func validateGroupInput(name string) error {
	if strings.TrimSpace(name) == "" {
		return fmt.Errorf("name is required")
	}
	if len(name) > 255 {
		return fmt.Errorf("name too long (max 255 characters)")
	}
	return nil
}