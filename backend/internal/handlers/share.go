package handlers

import (
	"net/http"
	"serpa-maps/internal/models"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func SharePlaceWithGroup(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		groupID := c.Param("id")

		var requester models.GroupMember
		if err := db.Where("group_id = ? AND user_id = ?", groupID, userID).First(&requester).Error; err != nil {
			c.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this group"})
			return
		}

		var payload struct {
			PlaceID string `json:"place_id"`
		}
		if err := c.ShouldBindJSON(&payload); err != nil || strings.TrimSpace(payload.PlaceID) == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "place_id is required"})
			return
		}

		var place models.Place
		if err := db.Where("place_id = ? AND user_id = ?", payload.PlaceID, userID).First(&place).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Place not found or you don't have permission"})
			return
		}

		share := models.PlaceShare{
			GroupID:    uuid.MustParse(groupID),
			PlaceID:    place.PlaceID,
			SharedByID: userID,
		}
		if err := db.Create(&share).Error; err != nil {
			c.JSON(http.StatusConflict, gin.H{"error": "Place already shared with this group"})
			return
		}

		c.JSON(http.StatusCreated, share)
	}
}

func GetGroupPlaces(db *gorm.DB, assetURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		groupID := c.Param("id")

		var requester models.GroupMember
		if err := db.Where("group_id = ? AND user_id = ?", groupID, userID).First(&requester).Error; err != nil {
			c.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this group"})
			return
		}

		var shares []models.PlaceShare
		if err := db.Where("group_id = ?", groupID).Find(&shares).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch shared places"})
			return
		}

		placeIDs := make([]uuid.UUID, len(shares))
		for i, s := range shares {
			placeIDs[i] = s.PlaceID
		}

		var places []models.Place
		if err := db.Where("place_id IN ?", placeIDs).Order("place_id").Find(&places).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch places"})
			return
		}

		for i, p := range places {
			var assets []models.Asset
			if err := db.Where("place_id = ?", p.PlaceID).Order("position").Find(&assets).Error; err != nil || assets == nil {
				assets = []models.Asset{}
			}
			places[i].Assets = assets
		}

		c.JSON(http.StatusOK, places)
	}
}

func UnsharePlace(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		groupID := c.Param("id")
		placeID := c.Param("place_id")

		var requester models.GroupMember
		if err := db.Where("group_id = ? AND user_id = ?", groupID, userID).First(&requester).Error; err != nil {
			c.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this group"})
			return
		}

		var place models.Place
		isOwner := db.Where("place_id = ? AND user_id = ?", placeID, userID).First(&place).Error == nil

		if !isOwner && requester.Role != "admin" {
			c.JSON(http.StatusForbidden, gin.H{"error": "Only the place owner or a group admin can unshare"})
			return
		}

		result := db.Delete(&models.PlaceShare{}, "group_id = ? AND place_id = ?", groupID, placeID)
		if result.Error != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to unshare place", "details": result.Error.Error()})
			return
		}
		if result.RowsAffected == 0 {
			c.JSON(http.StatusNotFound, gin.H{"error": "Shared place not found"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Place unshared successfully"})
	}
}