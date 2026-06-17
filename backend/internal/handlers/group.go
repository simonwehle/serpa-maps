package handlers

import (
	"net/http"

	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func CreateGroup(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		var group models.Group
		if err := c.ShouldBindJSON(&group); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
			return
		}

		if err := validateGroupInput(group.Name); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		group.UserID = userID

		if err := db.Create(&group).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create group", "details": err.Error()})
			return
		}

		member := models.GroupMember{
			GroupID: group.GroupID,
			UserID:  userID,
			Role:    "admin",
		}
		if err := db.Create(&member).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add creator as member", "details": err.Error()})
			return
		}

		resp := models.GroupWithRole{
			GroupID:     group.GroupID,
			Name:        group.Name,
			Description: group.Description,
			CreatedAt:   group.CreatedAt,
			Role:        member.Role,
		}
		c.JSON(http.StatusCreated, resp)
	}
}

func GetGroups(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		var members []models.GroupMember
		if err := db.Where("user_id = ?", userID).Find(&members).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch groups"})
			return
		}

		groupIDs := make([]uuid.UUID, len(members))
		for i, m := range members {
			groupIDs[i] = m.GroupID
		}

		var groups []models.Group
		       if err := db.Where("group_id IN ?", groupIDs).Order("group_id").Find(&groups).Error; err != nil {
			       c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch groups"})
			       return
		       }
		       groupRoleMap := make(map[uuid.UUID]string)
		       for _, m := range members {
			       groupRoleMap[m.GroupID] = m.Role
		       }
		       resp := make([]models.GroupWithRole, 0, len(groups))
		       for _, g := range groups {
			       resp = append(resp, models.GroupWithRole{
				       GroupID:     g.GroupID,
				       Name:        g.Name,
				       Description: g.Description,
				       CreatedAt:   g.CreatedAt,
				       Role:        groupRoleMap[g.GroupID],
			       })
		       }
		       c.JSON(http.StatusOK, resp)
	}
}

func GetGroupPlaces(db *gorm.DB) gin.HandlerFunc {
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

func DeleteGroup(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		groupID := c.Param("id")

		result := db.Delete(&models.Group{}, "group_id = ? AND user_id = ?", groupID, userID)
		if result.Error != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete group", "details": result.Error.Error()})
			return
		}
		if result.RowsAffected == 0 {
			c.JSON(http.StatusNotFound, gin.H{"error": "Group not found or you don't have permission"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Group deleted successfully"})
	}
}
