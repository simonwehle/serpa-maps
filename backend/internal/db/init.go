package db

import (
	"serpa-maps/internal/models"

	"gorm.io/gorm"
)

func InitDB(db *gorm.DB) error {
	return db.AutoMigrate(
		&models.Category{},
		&models.Place{},
		&models.Asset{},
	)
}
