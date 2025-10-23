package db

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"serpa-maps/internal/models"
)

var DB *gorm.DB

func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

func loadEnv() string {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using default values")
	}

	return fmt.Sprintf(
		"host=%s port= %s user=%s password=%s dbname=%s",
		getEnv("DB_HOST", "database"),
		getEnv("DB_PORT", "5432"),
		getEnv("DB_USERNAME", "postgres"),
		getEnv("DB_PASSWORD", "postgres"),
		getEnv("DB_DATABASE_NAME", "serpa-maps"),
	)
}

func InitDB() {
	var err error
	dsn := loadEnv()
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatal("Failed to connect to database. \n", err)
	}

	err = DB.AutoMigrate(&models.Category{}, &models.Place{}, &models.Asset{})
	if err != nil {
		log.Fatal("Failed to migrate database. \n", err)
	}
}