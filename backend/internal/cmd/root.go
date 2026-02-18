package cmd

import (
	"log"

	"github.com/gin-gonic/gin"

	"serpa-maps/internal/db"
	"serpa-maps/internal/environment"
	"serpa-maps/internal/handlers"
	"serpa-maps/internal/middleware"
)

func Execute() {
	dbConfig := environment.LoadEnv()
	postgres, err := db.Connect(dbConfig)
	if err != nil {
		log.Fatalln(err)
	}

	if err := db.InitDB(postgres); err != nil {
		log.Fatalln(err)
	}
	log.Println("Database initialized")

	r := gin.Default()
	r.Use(middleware.CorsMiddleware())

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
	api.DELETE("/place/:id/asset/:asset_id", handlers.DeletePlaceAsset(postgres))

	r.Run(":53164")
}