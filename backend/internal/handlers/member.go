package handlers

import (
	"fmt"
	"net/http"
	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func GetGroupMembers(db *gorm.DB) gin.HandlerFunc {
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

		       var members []models.GroupMember
		       if err := db.Where("group_id = ?", groupID).Find(&members).Error; err != nil {
			       c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch members"})
			       return
		       }

		c.JSON(http.StatusOK, members)
	}
}

func RemoveGroupMember(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		groupID := c.Param("id")
		targetUserID := c.Param("user_id")

		var requester models.GroupMember
		if err := db.Where("group_id = ? AND user_id = ?", groupID, userID).First(&requester).Error; err != nil {
			c.JSON(http.StatusForbidden, gin.H{"error": "You are not a member of this group"})
			return
		}
		if requester.Role != "admin" && fmt.Sprintf("%v", userID) != targetUserID {
			c.JSON(http.StatusForbidden, gin.H{"error": "Only admins can remove other members"})
			return
		}

		result := db.Delete(&models.GroupMember{}, "group_id = ? AND user_id = ?", groupID, targetUserID)
		if result.Error != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to remove member", "details": result.Error.Error()})
			return
		}
		if result.RowsAffected == 0 {
			c.JSON(http.StatusNotFound, gin.H{"error": "Member not found"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Member removed successfully"})
	}
}