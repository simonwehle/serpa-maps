package db

import (
	"fmt"
	"net/url"
	"serpa-maps/internal/models"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func generateDatabaseConnectionString(config models.DatabaseConfiguration) string {
	u := &url.URL{
		Scheme: "postgres",
		User:   url.UserPassword(config.Username, config.Password),
		Host:   fmt.Sprintf("%s:%d", config.Host, config.Port),
		Path:   "/" + config.Database,
		RawQuery: "sslmode=disable",
	}
	return u.String()
}

func Connect(config models.DatabaseConfiguration) (*sqlx.DB, error) {
	dsn := generateDatabaseConnectionString(config)
	db, err := sqlx.Connect("postgres", dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to postgres: %w", err)
	}
	return db, nil
}
