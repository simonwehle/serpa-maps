package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Place struct {
	PlaceID     uuid.UUID `gorm:"type:uuid;primaryKey" json:"place_id"`
	UserID      uuid.UUID `gorm:"type:uuid;not null;index" json:"-"`
	User        User      `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
	Name        string    `gorm:"not null" json:"name"`
	Description string    `json:"description"`
	Latitude    float64   `gorm:"not null" json:"latitude"`
	Longitude   float64   `gorm:"not null" json:"longitude"`
	CategoryID  uuid.UUID `gorm:"type:uuid;not null;index" json:"category_id"`
	Category    Category  `gorm:"constraint:OnDelete:RESTRICT;" json:"-"`
	CreatedAt   time.Time `gorm:"autoCreateTime" json:"created_at"`
	Assets      []Asset   `gorm:"foreignKey:PlaceID;constraint:OnDelete:CASCADE" json:"assets,omitempty"`
}

func (p *Place) BeforeCreate(tx *gorm.DB) error {
    if p.PlaceID == uuid.Nil {
        p.PlaceID = uuid.Must(uuid.NewV7())
    }
    return nil
}

func (Place) TableName() string {
	return "places"
}