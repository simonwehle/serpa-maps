package models

import "time"

// TODO: maybe remove place_id from json

type Asset struct {
    AssetID   int       `gorm:"column:asset_id;primaryKey;autoIncrement" json:"asset_id"`
    PlaceID   int       `gorm:"column:place_id;not null" json:"place_id"`
    AssetURL  string    `gorm:"column:asset_url;not null" json:"asset_url"`
    AssetType string    `gorm:"column:asset_type;not null;check:asset_type IN ('image', 'video')" json:"asset_type"`
    Position  int       `gorm:"column:position;default:0" json:"position"`
    CreatedAt time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
}

func (Asset) TableName() string {
	return "assets"
}