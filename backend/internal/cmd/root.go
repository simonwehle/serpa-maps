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
	keyString, dbConfig := environment.LoadEnv()
	postgres, err := db.Connect(dbConfig)
	if err != nil {
		log.Fatalln(err)
	}

	if err := db.InitDB(postgres); err != nil {
		log.Fatalln(err)
	}
	log.Println("Database initialized")

	jwtKey := []byte(keyString)

	r := gin.Default()
	r.Use(middleware.CorsMiddleware())

	api := r.Group("/api/v1")

	api.POST("/register", handlers.Register(postgres, jwtKey))
	api.POST("/login", handlers.Login(postgres, jwtKey))

	protected := api.Group("/").Use(middleware.AuthMiddleware(jwtKey))

	protected.GET("/categories", handlers.GetCategories(postgres))
	protected.POST("/category", handlers.AddCategory(postgres))
	protected.PATCH("/category/:id", handlers.UpdateCategory(postgres))
	protected.DELETE("/category/:id", handlers.DeleteCategory(postgres))

	protected.GET("/places", handlers.GetPlaces(postgres))
	protected.POST("/place", handlers.AddPlace(postgres))
	protected.PATCH("/place/:id", handlers.UpdatePlace(postgres))
	protected.DELETE("/place/:id", handlers.DeletePlace(postgres))

	r.Static("/uploads", "./uploads")
	protected.POST("/place/:id/assets", handlers.UploadPlaceAssets(postgres))
	protected.PATCH("/place/:id/assets/positions", handlers.UpdateAssetPositions(postgres))
	protected.DELETE("/place/:id/asset/:asset_id", handlers.DeletePlaceAsset(postgres))

	r.Run(":53164")
}