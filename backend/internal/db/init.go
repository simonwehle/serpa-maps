package db

import (
	"serpa-maps/internal/models"

	"gorm.io/gorm"
)

func InitDB(db *gorm.DB) error {
	return db.AutoMigrate(
		&models.User{},
		&models.RefreshToken{},
		&models.Category{},
		&models.Place{},
		&models.Asset{},
		&models.Group{},
    	&models.GroupMember{},
		&models.GroupInvite{},
		&models.PlaceShare{},
	)
}
