package models

import (
	"time"

	"github.com/google/uuid"
)

type Place struct {
	PlaceID     uuid.UUID `json:"user_id"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Latitude    float64   `json:"latitude"`
	Longitude   float64   `json:"longitude"`
	CategoryID  int       `json:"category_id"`
	CreatedAt   time.Time `json:"created_at"`
	Assets      []Asset   `json:"assets"`
}