package db

import (
	"github.com/jmoiron/sqlx"
)

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
