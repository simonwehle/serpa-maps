package handlers

import (
	"fmt"
	"math"
	"net/http"
	"os"
	"strings"

	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func buildAssetURL(assetURL string) string {
	baseURL := os.Getenv("BASE_URL")
	if baseURL == "" {
		baseURL = "http://localhost:53164"
	}
	return fmt.Sprintf("%s/%s", baseURL, assetURL)
}

func validatePlaceInput(name string, latitude, longitude float64) error {
	if strings.TrimSpace(name) == "" {
		return fmt.Errorf("name is required")
	}
	if len(name) > 255 {
		return fmt.Errorf("name too long (max 255 characters)")
	}
	if latitude < -90 || latitude > 90 {
		return fmt.Errorf("invalid latitude (must be between -90 and 90)")
	}
	if longitude < -180 || longitude > 180 {
		return fmt.Errorf("invalid longitude (must be between -180 and 180)")
	}
	return nil
}

func round6(v float64) float64 {
	return math.Round(v*1e6) / 1e6
}

func AddPlace(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var place models.Place

        if err := c.ShouldBindJSON(&place); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        place.Latitude = round6(place.Latitude)
        place.Longitude = round6(place.Longitude)

		if err := validatePlaceInput(place.Name, place.Latitude, place.Longitude); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

        if err := db.Create(&place).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert place", "details": err.Error()})
            return
        }

        var assets []models.Asset
        if err := db.Where("place_id = ?", place.PlaceID).Order("position").Find(&assets).Error; err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }

        place.Assets = assets

		for i := range place.Assets {
			place.Assets[i].AssetURL = buildAssetURL(place.Assets[i].AssetURL)
		}

        c.JSON(http.StatusCreated, place)
    }
}

func GetPlaces(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var places []models.Place

        if err := db.Order("place_id").Find(&places).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

		for i, p := range places {
			var assets []models.Asset
			err := db.Where("place_id = ?", p.PlaceID).Order("position").Find(&assets).Error
			if err != nil || assets == nil {
				assets = []models.Asset{}
			}
			for j := range assets {
				assets[j].AssetURL = buildAssetURL(assets[j].AssetURL)
			}
			places[i].Assets = assets
		}

        c.JSON(http.StatusOK, places)
    }
}


func UpdatePlace(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id := c.Param("id")
        var payload map[string]interface{}

        if err := c.ShouldBindJSON(&payload); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        if len(payload) == 0 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "No fields to update"})
            return
        }

		if name, ok := payload["name"].(string); ok {
			if strings.TrimSpace(name) == "" {
				c.JSON(http.StatusBadRequest, gin.H{"error": "name cannot be empty"})
				return
			}
		}
		if lat, ok := payload["latitude"].(float64); ok {
			if lat < -90 || lat > 90 {
				c.JSON(http.StatusBadRequest, gin.H{"error": "invalid latitude"})
				return
			}
		}
		if lng, ok := payload["longitude"].(float64); ok {
			if lng < -180 || lng > 180 {
				c.JSON(http.StatusBadRequest, gin.H{"error": "invalid longitude"})
				return
			}
		}

        if lat, ok := payload["latitude"].(float64); ok {
            payload["latitude"] = round6(lat)
        }
        if lng, ok := payload["longitude"].(float64); ok {
            payload["longitude"] = round6(lng)
        }

        if err := db.Model(&models.Place{}).Where("place_id = ?", id).Updates(payload).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place", "details": err.Error()})
            return
        }

        var place models.Place
        if err := db.Where("place_id = ?", id).First(&place).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
            return
        }

        var assets []models.Asset
        if err := db.Where("place_id = ?", id).Order("position").Find(&assets).Error; err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }
		for i := range assets {
			assets[i].AssetURL = buildAssetURL(assets[i].AssetURL)
		}
		place.Assets = assets

        c.JSON(http.StatusOK, place)
    }
}


func DeletePlace(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        result := db.Delete(&models.Place{}, "place_id = ?", placeID)
        if result.Error != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete place", "details": result.Error.Error()})
            return
        }

        if result.RowsAffected == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Place deleted successfully"})
    }
}