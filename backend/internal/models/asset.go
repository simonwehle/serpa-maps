package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Asset struct {
	AssetID       uuid.UUID `gorm:"type:uuid;primaryKey;column:asset_id" json:"asset_id"`
	PlaceID       uuid.UUID `gorm:"type:uuid;not null;index;column:place_id" json:"place_id"`
	Place         Place     `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
	AssetFilename string    `gorm:"column:asset_filename;not null" json:"asset_filename"`
	AssetType     string    `gorm:"not null;check:asset_type IN ('image', 'video')" json:"asset_type"`
	Position      int       `gorm:"default:0" json:"position"`
	CreatedAt     time.Time `gorm:"autoCreateTime" json:"created_at"`
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