package models

import "time"

// TODO: maybe remove place_id from json

type Asset struct {
    AssetID   int       `db:"asset_id" json:"asset_id"`
    PlaceID   int       `db:"place_id" json:"place_id"`
    AssetURL  string    `db:"asset_url" json:"asset_url"`
    AssetType string    `db:"asset_type" json:"asset_type"`
    Position  int       `db:"position" json:"position"`
    CreatedAt time.Time `db:"created_at" json:"created_at"`
}