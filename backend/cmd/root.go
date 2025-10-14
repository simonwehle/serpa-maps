package cmd

import (
	"log"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"

	"serpa-maps/internal/db"
)

func Execute() {
    dsn := db.LoadEnv()

	postgres, err := sqlx.Connect("postgres", dsn)
    if err != nil {
        log.Fatalln(err)
    }

    if err := db.InitDB(postgres); err != nil {
        log.Fatalln(err)
    }

    log.Println("Database initialized")
}