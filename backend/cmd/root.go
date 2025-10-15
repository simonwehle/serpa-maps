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
	api.POST("/category", handlers.AddCategory(postgres))
	api.PATCH("/category/:id", handlers.UpdateCategory(postgres))
	api.DELETE("/category/:id", handlers.DeleteCategory(postgres))

	api.GET("/places", handlers.GetPlaces(postgres))
	api.POST("/place", handlers.AddPlace(postgres))
	api.PATCH("/place/:id", handlers.UpdatePlace(postgres))
	api.DELETE("/place/:id", handlers.DeletePlace(postgres))

	r.Static("/uploads", "./uploads")
	api.POST("/place/:id/assets", handlers.UploadPlaceAssets(postgres))
	api.PATCH("/place/:id/assets/positions", handlers.UpdateAssetPositions(postgres))
	api.DELETE("/place/:id/asset", )

	r.Run(":3465")
}