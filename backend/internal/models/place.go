package models

import (
	"time"

	"github.com/google/uuid"
)

type Place struct {
	PlaceID     uuid.UUID `gorm:"primaryKey;type:uuid;default:gen_random_uuid()" json:"user_id"`
	Name        string    `gorm:"not null" json:"name"`
	Description *string   `json:"description"`
	Latitude    float64   `gorm:"not null" json:"latitude"`
	Longitude   float64   `gorm:"not null" json:"longitude"`
	Category    Category  `gorm:"constraint:OnDelete:CASCADE" json:"category_id"`
	CreatedAt   time.Time `json:"created_at"`
	Assets      []Asset   `json:"assets"`
}