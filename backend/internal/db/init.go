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

	CREATE TABLE IF NOT EXISTS assets (
		asset_id SERIAL PRIMARY KEY,
		place_id INT NOT NULL REFERENCES places(place_id) ON DELETE CASCADE,
		asset_url TEXT NOT NULL,
		asset_type TEXT NOT NULL CHECK (asset_type IN ('image', 'video')),
		position INT NOT NULL DEFAULT 0,
		created_at TIMESTAMP DEFAULT NOW()
	);
	`
	_, err := db.Exec(schema)
	return err
}
