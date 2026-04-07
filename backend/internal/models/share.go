package models

import (
	"time"

	"github.com/google/uuid"
)

type PlaceShare struct {
    GroupID    uuid.UUID `gorm:"type:uuid;primaryKey" json:"group_id"`
    PlaceID    uuid.UUID `gorm:"type:uuid;primaryKey;index" json:"place_id"`
    SharedByID uuid.UUID `gorm:"type:uuid;not null" json:"-"`
    SharedAt   time.Time `gorm:"autoCreateTime" json:"shared_at"`
    Group      Group     `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
    Place      Place     `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
    SharedBy   User      `gorm:"foreignKey:SharedByID;constraint:OnDelete:CASCADE;" json:"-"`
}

func (PlaceShare) TableName() string {
    return "place_shares"
}