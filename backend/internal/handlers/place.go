package handlers

import (
	"fmt"
	"net/http"
	"strings"

	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func AddPlace(db *gorm.DB, assetURL string) gin.HandlerFunc {
    return func(c *gin.Context) {
        var payload struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }

        if err := c.ShouldBindJSON(&payload); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        userID, exists := c.Get("user_id")
        if !exists {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
            return
        }
        userIDStr := fmt.Sprintf("%v", userID)
        parsedUserID, err := uuid.Parse(userIDStr)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID format"})
            return
        }
        payload.Place.UserID = parsedUserID

        payload.Place.Latitude = round6(payload.Place.Latitude)
        payload.Place.Longitude = round6(payload.Place.Longitude)

	if err := validatePlaceInput(payload.Place.Name, payload.Place.Latitude, payload.Place.Longitude); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

        var existing models.Place
        err = db.Where("user_id = ? AND ABS(latitude - ?) < 0.000001 AND ABS(longitude - ?) < 0.000001", parsedUserID, payload.Place.Latitude, payload.Place.Longitude).First(&existing).Error
        if err == nil {
            c.JSON(http.StatusConflict, gin.H{"error": "An diesem Ort existiert bereits ein Platz."})
            return
        } else if err != gorm.ErrRecordNotFound {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Fehler bei der Platzprüfung", "details": err.Error()})
            return
        }

        if err := db.Create(&payload.Place).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert place", "details": err.Error()})
            return
        }

        for _, groupID := range payload.GroupIDs {
            gid, err := uuid.Parse(groupID)
            if err != nil {
                continue
            }
            share := models.PlaceShare{
                GroupID:    gid,
                PlaceID:    payload.Place.PlaceID,
                SharedByID: parsedUserID,
            }
            _ = db.Create(&share)
        }

        var assets []models.Asset
        if err := db.Where("place_id = ?", payload.Place.PlaceID).Order("position").Find(&assets).Error; err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }

        for i := range assets {
            assets[i].AssetURL = buildAssetURL(assetURL, assets[i].AssetFilename)
        }

        payload.Place.Assets = assets

        type PlaceWithGroups struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }

        response := PlaceWithGroups{
            Place:    payload.Place,
            GroupIDs: payload.GroupIDs,
        }

        c.JSON(http.StatusCreated, response)
    }
}

func GetPlaces(db *gorm.DB, assetURL string) gin.HandlerFunc {
	return func(c *gin.Context) {
		parsedUserID, ok := parseUserID(c)
		if !ok {
			return
		}

		sharedPlaceIDs := getSharedPlaceIDs(db, parsedUserID)
		query := db.Where("user_id = ?", parsedUserID)
		if len(sharedPlaceIDs) > 0 {
			query = query.Or("place_id IN ?", sharedPlaceIDs)
		}
		var places []models.Place
		if err := query.Order("place_id").Find(&places).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

        type PlaceWithGroups struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }
        var result []PlaceWithGroups
        for i, p := range places {
            var assets []models.Asset
            err := db.Where("place_id = ?", p.PlaceID).Order("position").Find(&assets).Error
            if err != nil || assets == nil {
                assets = []models.Asset{}
            }
            for j := range assets {
                assets[j].AssetURL = buildAssetURL(assetURL, assets[j].AssetFilename)
            }
            places[i].Assets = assets

            var shares []models.PlaceShare
            groupIDs := []string{}
            if err := db.Where("place_id = ?", p.PlaceID).Find(&shares).Error; err == nil {
                for _, share := range shares {
                    groupIDs = append(groupIDs, share.GroupID.String())
                }
            }
            result = append(result, PlaceWithGroups{
                Place:    places[i],
                GroupIDs: groupIDs,
            })
        }

        c.JSON(http.StatusOK, result)
	}
}


func UpdatePlace(db *gorm.DB, assetURLBase string) gin.HandlerFunc {
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

        userID, exists := c.Get("user_id")
        if !exists {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
            return
        }
        userIDStr := fmt.Sprintf("%v", userID)
        parsedUserID, err := uuid.Parse(userIDStr)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID format"})
            return
        }

        var existingPlace models.Place
        if err = db.Where("place_id = ? AND user_id = ?", id, parsedUserID).First(&existingPlace).Error; err != nil {
            if err == gorm.ErrRecordNotFound {
                c.JSON(http.StatusNotFound, gin.H{"error": "Place not found or you don't have permission"})
            } else {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
            }
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

		var groupIDs []interface{}
		if ids, ok := payload["group_ids"].([]interface{}); ok {
			groupIDs = ids
			delete(payload, "group_ids")
		}

        if lat, ok := payload["latitude"].(float64); ok {
            payload["latitude"] = round6(lat)
        }
        if lng, ok := payload["longitude"].(float64); ok {
            payload["longitude"] = round6(lng)
        }
        if err := db.Model(&models.Place{}).Where("place_id = ? AND user_id = ?", id, parsedUserID).Updates(payload).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place", "details": err.Error()})
            return
        }

		if groupIDs != nil {
			var currentShares []models.PlaceShare
			db.Where("place_id = ?", id).Find(&currentShares)
			currentGroupIDs := make(map[string]bool)
			for _, share := range currentShares {
				currentGroupIDs[share.GroupID.String()] = true
			}

			newGroupIDs := make(map[string]bool)
			for _, item := range groupIDs {
				gid := item.(string)
				newGroupIDs[gid] = true

				if _, exists := currentGroupIDs[gid]; !exists {
					parsedGID, err := uuid.Parse(gid)
					if err == nil {
						share := models.PlaceShare{
							GroupID:    parsedGID,
							PlaceID:    existingPlace.PlaceID,
							SharedByID: parsedUserID,
						}
						db.Create(&share)
					}
				}
			}

			for gidStr := range currentGroupIDs {
				if _, exists := newGroupIDs[gidStr]; !exists {
					db.Where("place_id = ? AND group_id = ?", id, gidStr).Delete(&models.PlaceShare{})
				}
			}
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
            assets[i].AssetURL = buildAssetURL(assetURLBase, assets[i].AssetFilename)
        }

        place.Assets = assets

        var shares []models.PlaceShare
        finalGroupIDs := []string{}
        if err := db.Where("place_id = ?", place.PlaceID).Find(&shares).Error; err == nil {
            for _, share := range shares {
                finalGroupIDs = append(finalGroupIDs, share.GroupID.String())
            }
        }

        type PlaceWithGroups struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }

        response := PlaceWithGroups{
            Place:    place,
            GroupIDs: finalGroupIDs,
        }

        c.JSON(http.StatusOK, response)
    }
}


func DeletePlace(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        userID, exists := c.Get("user_id")
        if !exists {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
            return
        }
        userIDStr := fmt.Sprintf("%v", userID)
        parsedUserID, err := uuid.Parse(userIDStr)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID format"})
            return
        }

        result := db.Delete(&models.Place{}, "place_id = ? AND user_id = ?", placeID, parsedUserID)
        if result.Error != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete place", "details": result.Error.Error()})
            return
        }

        if result.RowsAffected == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found or you don't have permission"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Place deleted successfully"})
    }
}