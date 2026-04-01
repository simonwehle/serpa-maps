package handlers

import (
	"net/http"
	"serpa-maps/internal/models"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func InviteToGroup(db *gorm.DB) gin.HandlerFunc {
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
			Username string `json:"username"`
		}
		if err := c.ShouldBindJSON(&payload); err != nil || strings.TrimSpace(payload.Username) == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "username is required"})
			return
		}

		var invitee models.User
		if err := db.Where("username = ?", payload.Username).First(&invitee).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
			return
		}

		var existing models.GroupInvite
		if err := db.Where("group_id = ? AND invitee_id = ?", groupID, invitee.UserID).First(&existing).Error; err == nil {
			c.JSON(http.StatusConflict, gin.H{"error": "User already invited or a member"})
			return
		}

		invite := models.GroupInvite{
			GroupID:     uuid.MustParse(groupID),
			InvitedByID: userID,
			InviteeID:   invitee.UserID,
			Status:      "pending",
		}
		if err := db.Create(&invite).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create invite", "details": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, invite)
	}
}

func GetMyInvites(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		   	var invites []models.GroupInvite
			if err := db.Preload("Group").Preload("InvitedBy").Where("invitee_id = ? AND status = 'pending'", userID).Find(&invites).Error; err != nil {
			   c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch invites"})
			   return
		   }

		   var result []gin.H
		   for _, invite := range invites {
			   result = append(result, gin.H{
				   "group_invite_id": invite.GroupInviteID,
				   "group_id": invite.GroupID,
				   "group_name": invite.Group.Name,
				   "invited_by_id": invite.InvitedByID,
				   "invited_by_username": invite.InvitedBy.Username,
				   "status": invite.Status,
				   "created_at": invite.CreatedAt,
				   "responded_at": invite.RespondedAt,
			   })
		   }
		   c.JSON(http.StatusOK, result)
	}
}

func RespondToInvite(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := parseUserID(c)
		if !ok {
			return
		}

		inviteID := c.Param("id")

		var payload struct {
			Status string `json:"status"` // "accepted" | "declined"
		}
		if err := c.ShouldBindJSON(&payload); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
			return
		}
		if payload.Status != "accepted" && payload.Status != "declined" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "status must be 'accepted' or 'declined'"})
			return
		}

		var invite models.GroupInvite
		if err := db.Where("group_invite_id = ? AND invitee_id = ? AND status = 'pending'", inviteID, userID).First(&invite).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Invite not found"})
			return
		}

		now := time.Now()
		invite.Status = payload.Status
		invite.RespondedAt = &now

		if err := db.Save(&invite).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update invite", "details": err.Error()})
			return
		}

		if payload.Status == "accepted" {
			member := models.GroupMember{
				GroupID: invite.GroupID,
				UserID:  userID,
				Role:    "member",
			}
			if err := db.Create(&member).Error; err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add member", "details": err.Error()})
				return
			}
		}

		c.JSON(http.StatusOK, invite)
	}
}