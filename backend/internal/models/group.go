package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Group struct {
    GroupID     uuid.UUID `gorm:"type:uuid;primaryKey" json:"group_id"`
    UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"-"`
    User        User      `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
    Name        string    `gorm:"not null" json:"name"`
    Description string    `json:"description"`
    CreatedAt   time.Time `gorm:"autoCreateTime" json:"created_at"`
    Members     []GroupMember `gorm:"foreignKey:GroupID;constraint:OnDelete:CASCADE" json:"members,omitempty"`
    PlaceShares []PlaceShare  `gorm:"foreignKey:GroupID;constraint:OnDelete:CASCADE" json:"place_shares,omitempty"`
}

func (g *Group) BeforeCreate(tx *gorm.DB) error {
    if g.GroupID == uuid.Nil {
        g.GroupID = uuid.Must(uuid.NewV7())
    }
    return nil
}

func (Group) TableName() string {
    return "groups"
}