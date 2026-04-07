package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type GroupInvite struct {
    GroupInviteID uuid.UUID  `gorm:"type:uuid;primaryKey" json:"group_invite_id"`
    GroupID       uuid.UUID  `gorm:"type:uuid;not null;uniqueIndex:idx_group_invitee" json:"group_id"`
    InvitedByID   uuid.UUID  `gorm:"type:uuid;not null;index" json:"-"`
    InviteeID     uuid.UUID  `gorm:"type:uuid;not null;uniqueIndex:idx_group_invitee" json:"invitee_id"`
    Status        string     `gorm:"not null;default:'pending'" json:"status"` // "pending" | "accepted" | "declined"
    CreatedAt     time.Time  `gorm:"autoCreateTime" json:"created_at"`
    RespondedAt   *time.Time `json:"responded_at,omitempty"`
    Group         Group      `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
    InvitedBy     User       `gorm:"foreignKey:InvitedByID;constraint:OnDelete:CASCADE;" json:"-"`
    Invitee       User       `gorm:"foreignKey:InviteeID;constraint:OnDelete:CASCADE;" json:"invitee,omitempty"`
}

func (g *GroupInvite) BeforeCreate(tx *gorm.DB) error {
    if g.GroupInviteID == uuid.Nil {
        g.GroupInviteID = uuid.Must(uuid.NewV7())
    }
    return nil
}

func (GroupInvite) TableName() string {
    return "group_invites"
}

type GroupInviteResponse struct {
	GroupInviteID     uuid.UUID  `json:"group_invite_id"`
	GroupID           uuid.UUID  `json:"group_id"`
	GroupName         string     `json:"group_name,omitempty"`
	InvitedByID       uuid.UUID  `json:"invited_by_id"`
	InvitedByUsername string     `json:"invited_by_username,omitempty"`
	InviteeID         uuid.UUID  `json:"invitee_id"`
	InviteeUsername   string     `json:"invitee_username,omitempty"`
	Status            string     `json:"status"`
	CreatedAt         time.Time  `json:"created_at"`
	RespondedAt       *time.Time `json:"responded_at,omitempty"`
}