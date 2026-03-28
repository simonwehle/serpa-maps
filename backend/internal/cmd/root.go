package cmd

import (
	"log"
	"strings"

	"github.com/gin-gonic/gin"

	"serpa-maps/internal/db"
	"serpa-maps/internal/environment"
	"serpa-maps/internal/handlers"
	"serpa-maps/internal/middleware"
	"serpa-maps/internal/models"
)

func Execute() {
	urlConfig, jwtSecrets, dbConfig := environment.LoadEnv()
	postgres, err := db.Connect(dbConfig)
	if err != nil {
		log.Fatalln(err)
	}

	if err := db.InitDB(postgres); err != nil {
		log.Fatalln(err)
	}
	log.Println("Database initialized")

	jwtKeys := models.JwtKeys {
		AccessKey: []byte(jwtSecrets.AccessSecret),
		RefreshKey: []byte(jwtSecrets.RefreshSecret),
	}

	assetStorageDir := "assets"
	assetURLPrefix := "/assets"
	assetURL := strings.TrimRight(urlConfig.AssetBaseUrl, "/") + "/" + strings.Trim(assetURLPrefix, "/")

	r := gin.Default()
	r.Use(middleware.CorsMiddleware(urlConfig.CorsOrigin))

	api := r.Group("/api/v1")

	api.GET("/health", handlers.Health())

	api.POST("/register", handlers.Register(postgres, jwtKeys))
	api.POST("/login", handlers.Login(postgres, jwtKeys))
	api.POST("/logout", handlers.Logout(postgres, jwtKeys.RefreshKey))
	api.POST("/refresh", handlers.Refresh(postgres, jwtKeys))

	protected := api.Group("/").Use(middleware.AuthMiddleware(jwtKeys.AccessKey))

	protected.GET("/categories", handlers.GetCategories(postgres))
	protected.POST("/category", handlers.AddCategory(postgres))
	protected.PATCH("/category/:id", handlers.UpdateCategory(postgres))
	protected.DELETE("/category/:id", handlers.DeleteCategory(postgres))

	protected.GET("/places", handlers.GetPlaces(postgres, assetURL))
	protected.POST("/place", handlers.AddPlace(postgres, assetURL))
	protected.PATCH("/place/:id", handlers.UpdatePlace(postgres, assetURL))
	protected.DELETE("/place/:id", handlers.DeletePlace(postgres))

	protected.POST("/place/:id/assets", handlers.UploadPlaceAssets(postgres, assetStorageDir, assetURL))
	protected.PATCH("/place/:id/assets/positions", handlers.UpdateAssetPositions(postgres))
	protected.DELETE("/place/:id/asset/:asset_id", handlers.DeletePlaceAsset(postgres, assetStorageDir))

	protected.POST("/group", handlers.CreateGroup(postgres))
	protected.GET("/groups", handlers.GetGroups(postgres))
	protected.DELETE("/group/:id", handlers.DeleteGroup(postgres))

	protected.GET("/group/:id/members", handlers.GetGroupMembers(postgres))
	protected.DELETE("/group/:id/member/:user_id", handlers.RemoveGroupMember(postgres))

	protected.POST("/group/:id/invite", handlers.InviteToGroup(postgres))
	protected.GET("/invites", handlers.GetMyInvites(postgres))
	protected.PATCH("/invite/:id", handlers.RespondToInvite(postgres))

	protected.POST("/group/:id/place", handlers.SharePlaceWithGroup(postgres))
	protected.GET("/group/:id/places", handlers.GetGroupPlaces(postgres, assetURL))
	protected.DELETE("/group/:id/place/:place_id", handlers.UnsharePlace(postgres))

	r.Run(":53964")
}