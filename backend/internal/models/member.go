package models

import (
	"time"

	"github.com/google/uuid"
)

type GroupMember struct {
    GroupID  uuid.UUID `gorm:"type:uuid;primaryKey" json:"group_id"`
    UserID   uuid.UUID `gorm:"type:uuid;primaryKey;index" json:"user_id"`
    Role     string    `gorm:"not null;default:'member'" json:"role"` // "admin" | "member"
    JoinedAt time.Time `gorm:"autoCreateTime" json:"joined_at"`
    Group    Group     `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
    User     User      `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
}

func (GroupMember) TableName() string {
    return "group_members"
}