package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Category struct {
	CategoryID  uuid.UUID  `gorm:"type:uuid;primaryKey" json:"category_id"`
	UserID      uuid.UUID  `gorm:"type:uuid;column:user_id;not null" json:"-"`
	User        User       `gorm:"foreignKey:UserID;constraint:OnDelete:CASCADE" json:"-"`
	Name        string     `gorm:"column:name;not null" json:"name"`
	Icon        string     `gorm:"column:icon" json:"icon"`
	Color       string     `gorm:"column:color" json:"color"`
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