package cmd

import (
	"log"

	"github.com/gin-gonic/gin"

	"serpa-maps/internal/db"
	"serpa-maps/internal/handlers"
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

	r := gin.Default()

	api := r.Group("/api/v1")

	api.GET("/categories", handlers.GetCategories(postgres))
	api.GET("/places", handlers.GetPlaces(postgres))
	api.POST("/category", handlers.AddCategory(postgres))
	api.POST("/place", handlers.AddPlace(postgres))

	r.Run(":3465")
}