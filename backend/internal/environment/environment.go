package environment

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"

	"serpa-maps/internal/models"
)

func getEnv(key, fallback string) string {
    value, exists := os.LookupEnv(key)
    if !exists {
        value = fallback
    }
    return value
}

func getRequiredEnv(key string) string {
    value, exists := os.LookupEnv(key)
    if !exists || value == "" {
        log.Fatalf("%s environment variable is required", key)
    }
    return value
}

func createDatabaseConfiguration() models.DatabaseConfiguration {
	portStr := getEnv("DB_PORT", "5432")
	port, err := strconv.Atoi(portStr)
	if err != nil {
		log.Printf("invalid DB_PORT %q, defaulting to 5432", portStr)
		port = 5432
	}

	return models.DatabaseConfiguration{
		Username: getEnv("DB_USERNAME", "postgres"),
		Password: getRequiredEnv("DB_PASSWORD"),
		Database: getEnv("DB_DATABASE_NAME", "serpa-maps"),
		Host:     getEnv("DB_HOST", "database"),
		Port:     port,
	}
}

func LoadEnv() models.DatabaseConfiguration {
	err := godotenv.Load()
	if err != nil {
		log.Println(".env file not found, using environment variables")
	}
	return createDatabaseConfiguration()
}