package db

import (
	"fmt"
	"log"
	"os"

	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func getEnv(key, fallback string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return fallback
}

func LoadEnv() string {
    // TODO: remove godotenv for production
    if err := godotenv.Load(); err != nil {
        log.Println("No .env file found, using environment variables")
    }

    dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable",
        getEnv("DB_USERNAME", "postgres"),
        getEnv("DB_PASSWORD", "postgres"),
        getEnv("DB_HOST", "database"),
        getEnv("DB_PORT", "5432"),
        getEnv("DB_DATABASE_NAME", "serpa-maps"),
    )
    return dsn
}

func InitDB(db *sqlx.DB) error {
    schema := `
    CREATE TABLE IF NOT EXISTS categories (
        category_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT,
        color TEXT
    );

    CREATE TABLE IF NOT EXISTS places (
        place_id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        latitude DOUBLE PRECISION NOT NULL,
        longitude DOUBLE PRECISION NOT NULL,
        category_id INT REFERENCES categories(category_id),
        created_at TIMESTAMPTZ DEFAULT now()
    );
    `
    _, err := db.Exec(schema)
    return err
}