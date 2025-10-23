package models

import "time"

// TODO: add UUID later

type Place struct {
	PlaceID     int       `db:"place_id" json:"place_id"`
	//UserID      int     `db:"user_id" json:"user_id"`
	Name        string    `db:"name" json:"name"`
	Description string    `db:"description" json:"description"`
	Latitude    float64   `db:"latitude" json:"latitude"`
	Longitude   float64   `db:"longitude" json:"longitude"`
	CategoryID  int       `db:"category_id" json:"category_id"`
	CreatedAt   time.Time `db:"created_at" json:"created_at"`
	Assets      []Asset   `json:"assets"`
}