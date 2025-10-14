package cmd

import (
	"log"

	"serpa-maps/internal/db"
)

func Execute() {
	postgres, err := db.Connect()
	if err != nil {
		log.Fatalln(err)
	}

	if err := db.InitDB(postgres); err != nil {
		log.Fatalln(err)
	}

	log.Println("Database initialized")
}