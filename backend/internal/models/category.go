package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Category struct {
	CategoryID uuid.UUID `gorm:"type:uuid;primaryKey" json:"category_id"`
	UserID     uuid.UUID `gorm:"type:uuid;not null;index" json:"-"`
	User       User      `gorm:"constraint:OnDelete:CASCADE;" json:"-"`
	Name       string    `gorm:"not null" json:"name"`
	Icon       string    `json:"icon"`
	Color      string    `json:"color"`
}

func (c *Category) BeforeCreate(tx *gorm.DB) error {
    if c.CategoryID == uuid.Nil {
        c.CategoryID = uuid.Must(uuid.NewV7())
    }
    return nil
}

func (Category) TableName() string {
	return "categories"
}