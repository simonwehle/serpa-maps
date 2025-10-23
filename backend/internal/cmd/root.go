package cmd

import (
	"serpa-maps/internal/db"
)

func Execute() {
	db.InitDB()
}