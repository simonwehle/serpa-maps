package handlers

import (
	"fmt"
	"net/http"

	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func AddPlace(db *gorm.DB) gin.HandlerFunc {
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

        assets := []models.Asset{}
        if err := db.Where("place_id = ?", payload.Place.PlaceID).Order("position").Find(&assets).Error; err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }

        payload.Place.Assets = assets

        type PlaceWithGroups struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }

        groupIDs := payload.GroupIDs
        if groupIDs == nil {
            groupIDs = []string{}
        }

        response := PlaceWithGroups{
            Place:    payload.Place,
            GroupIDs: groupIDs,
        }

        c.JSON(http.StatusCreated, response)
    }
}

func GetPlaces(db *gorm.DB) gin.HandlerFunc {
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
		result := []PlaceWithGroups{}
		for i, p := range places {
			assets := []models.Asset{}
			err := db.Where("place_id = ?", p.PlaceID).Order("position").Find(&assets).Error
			if err != nil {
				assets = []models.Asset{}
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


func UpdatePlace(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id := c.Param("id")

        var payload struct {
            models.Place
            GroupIDs []string `json:"group_ids"`
        }

        if err := c.ShouldBindJSON(&payload); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        if err := validatePlaceInput(payload.Name, payload.Latitude, payload.Longitude); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        if payload.CategoryID == uuid.Nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "category_id is required"})
            return
        }

        parsedUserID, ok := parseUserID(c)
        if !ok {
            return
        }

        placeID, err := uuid.Parse(id)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place ID"})
            return
        }

        if err := hasPlacePermission(db, parsedUserID, placeID, "editor"); err != nil {
            c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
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

        if payload.Latitude < -90 || payload.Latitude > 90 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "invalid latitude"})
            return
        }

        if payload.Longitude < -180 || payload.Longitude > 180 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "invalid longitude"})
            return
        }

        payload.Latitude = round6(payload.Latitude)
        payload.Longitude = round6(payload.Longitude)

        updates := map[string]interface{}{
            "name":        payload.Name,
            "description": payload.Description,
            "latitude":    payload.Latitude,
            "longitude":   payload.Longitude,
            "category_id": payload.CategoryID,
        }

        if err := db.Model(&models.Place{}).Where("place_id = ? AND user_id = ?", id, parsedUserID).Updates(updates).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place", "details": err.Error()})
            return
        }

        if payload.GroupIDs != nil {
			var currentShares []models.PlaceShare
			db.Where("place_id = ?", id).Find(&currentShares)
			currentGroupIDs := make(map[string]bool)
			for _, share := range currentShares {
				currentGroupIDs[share.GroupID.String()] = true
			}

			newGroupIDs := make(map[string]bool)
            for _, gid := range payload.GroupIDs {
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

        assets := []models.Asset{}
        if err := db.Where("place_id = ?", id).Order("position").Find(&assets).Error; err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
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

        parsedPlaceID, err := uuid.Parse(placeID)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place ID"})
            return
        }

        if err := hasPlacePermission(db, parsedUserID, parsedPlaceID, "admin"); err != nil {
            c.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
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