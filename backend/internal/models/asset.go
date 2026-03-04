package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Asset struct {
    AssetID   uuid.UUID `gorm:"type:uuid;primaryKey" json:"asset_id"`
    PlaceID   uuid.UUID `gorm:"column:place_id;not null" json:"place_id"`
    AssetURL  string    `gorm:"column:asset_url;not null" json:"asset_url"`
    AssetType string    `gorm:"column:asset_type;not null;check:asset_type IN ('image', 'video')" json:"asset_type"`
    Position  int       `gorm:"column:position;default:0" json:"position"`
    CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
}

func (a *Asset) BeforeCreate(tx *gorm.DB) error {
    if a.AssetID == uuid.Nil {
        a.AssetID = uuid.Must(uuid.NewV7())
    }
    return nil
}

func (Asset) TableName() string {
	return "assets"
}