package handlers

import (
	"fmt"
	"net/http"
	"time"

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
				if err := db.Preload("User").Where("group_id = ?", groupID).Find(&members).Error; err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch members"})
					return
				}

				var invites []models.GroupInvite
				if err := db.Preload("Invitee").Where("group_id = ? AND status = ?", groupID, "pending").Find(&invites).Error; err != nil {
					c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch invited members"})
					return
				}

				type MemberResponse struct {
					UserID   string `json:"user_id"`
					Username string `json:"username"`
					Role     string `json:"role"`
					JoinedAt *string `json:"joined_at,omitempty"`
				}
				responses := make([]MemberResponse, 0, len(members)+len(invites))
				for _, m := range members {
					responses = append(responses, MemberResponse{
						UserID:   m.UserID.String(),
						Username: m.User.Username,
						Role:     m.Role,
						JoinedAt: func() *string { t := m.JoinedAt.Format(time.RFC3339); return &t }(),
					})
				}
				for _, inv := range invites {
					responses = append(responses, MemberResponse{
						UserID:   inv.InviteeID.String(),
						Username: inv.Invitee.Username,
						Role:     "pending",
						JoinedAt: nil,
					})
				}
				c.JSON(http.StatusOK, responses)
	}
}

func UpdateGroupMemberRole(db *gorm.DB) gin.HandlerFunc {
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

		if requester.Role != "admin" {
			c.JSON(http.StatusForbidden, gin.H{"error": "Only admins can update roles"})
			return
		}

		var body struct {
			Role string `json:"role" binding:"required"`
		}
		if err := c.ShouldBindJSON(&body); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
			return
		}

		validRoles := map[string]bool{"admin": true, "editor": true, "member": true}
		if !validRoles[body.Role] {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid role, must be admin, editor, or member"})
			return
		}

		if fmt.Sprintf("%v", userID) == targetUserID {
			c.JSON(http.StatusBadRequest, gin.H{"error": "You cannot change your own role"})
			return
		}

		result := db.Model(&models.GroupMember{}).
			Where("group_id = ? AND user_id = ?", groupID, targetUserID).
			Update("role", body.Role)

		if result.Error != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update role"})
			return
		}
		if result.RowsAffected == 0 {
			c.JSON(http.StatusNotFound, gin.H{"error": "Member not found"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Role updated successfully"})
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