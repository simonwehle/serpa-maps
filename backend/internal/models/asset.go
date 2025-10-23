package models

import (
	"time"

	"github.com/google/uuid"
)

type Asset struct {
    AssetID   uuid.UUID  `json:"asset_id"`
    PlaceID   int       `json:"place_id"`
    AssetURL  string    `json:"asset_url"`
    AssetType string    `json:"asset_type"`
    Position  int       `json:"position"`
    CreatedAt time.Time `json:"created_at"`
}