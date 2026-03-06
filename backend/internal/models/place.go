package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Place struct {
	PlaceID     uuid.UUID `gorm:"type:uuid;primaryKey" json:"place_id"`
	UserID      uuid.UUID `gorm:"type:uuid;column:user_id;not null" json:"-"`
	User        User      `gorm:"foreignKey:UserID;constraint:OnDelete:CASCADE" json:"-"`
	Name        string    `gorm:"column:name;not null" json:"name"`
	Description string    `gorm:"column:description" json:"description"`
	Latitude    float64   `gorm:"column:latitude;not null" json:"latitude"`
	Longitude   float64   `gorm:"column:longitude;not null" json:"longitude"`
	CategoryID  uuid.UUID `gorm:"type:uuid;not null;column:category_id" json:"category_id"`
	Category    Category  `gorm:"foreignKey:CategoryID;constraint:OnDelete:RESTRICT" json:"-"`
	CreatedAt   time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	Assets      []Asset   `gorm:"foreignKey:PlaceID" json:"assets"`
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