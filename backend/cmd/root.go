package cmd

import (
	"fmt"
	"log"
	"os"

	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"

	"serpa-maps/internal/db"
)

func getEnv(key, fallback string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return fallback
}


func Execute() {
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

	postgres, err := sqlx.Connect("postgres", dsn)
    if err != nil {
        log.Fatalln(err)
    }

    if err := db.InitDB(postgres); err != nil {
        log.Fatalln(err)
    }

    log.Println("Database initialized")
}