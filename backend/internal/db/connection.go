package db

import (
	"fmt"
	"serpa-maps/internal/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func generateDatabaseConnectionString(config models.DatabaseConfiguration) string {
	return fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		config.Host,
		config.Port,
		config.Username,
		config.Password,
		config.Database,
	)
}

func Connect(config models.DatabaseConfiguration) (*gorm.DB, error) {
	dsn := generateDatabaseConnectionString(config)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to postgres: %w", err)
	}
	return db, nil
}
