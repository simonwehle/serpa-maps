package handlers

import (
	"fmt"
	"net/http"
	"strings"

	"serpa-maps/internal/models"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func AddPlace(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var place models.Place

        if err := c.ShouldBindJSON(&place); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        query := `
            INSERT INTO places (name, description, latitude, longitude, category_id)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING place_id, created_at;
        `

        err := db.QueryRow(query, place.Name, place.Description, place.Latitude, place.Longitude, place.CategoryID).
            Scan(&place.PlaceID, &place.CreatedAt)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert place", "details": err.Error()})
            return
        }

        var assets []models.Asset
        if err := db.Select(&assets, "SELECT * FROM assets WHERE place_id = $1 ORDER BY position", place.PlaceID); err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }

        place.Assets = assets

        c.JSON(http.StatusCreated, place)
    }
}

func GetPlaces(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var places []models.Place

        if err := db.Select(&places, "SELECT * FROM places ORDER BY place_id"); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

		for i, p := range places {
			var assets []models.Asset
			err := db.Select(&assets, "SELECT * FROM assets WHERE place_id = $1 ORDER BY position", p.PlaceID)
			if err != nil || assets == nil {
				assets = []models.Asset{}
			}
			places[i].Assets = assets
		}

        c.JSON(http.StatusOK, places)
    }
}


func UpdatePlace(db *sqlx.DB) gin.HandlerFunc {
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

        setClauses := []string{}
        args := []interface{}{}
        i := 1
        for k, v := range payload {
            setClauses = append(setClauses, fmt.Sprintf("%s = $%d", k, i))
            args = append(args, v)
            i++
        }
        args = append(args, id)

        query := fmt.Sprintf("UPDATE places SET %s WHERE place_id = $%d", strings.Join(setClauses, ", "), i)

        if _, err := db.Exec(query, args...); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update place", "details": err.Error()})
            return
        }

        var place models.Place
        if err := db.Get(&place, "SELECT * FROM places WHERE place_id = $1", id); err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
            return
        }

        var assets []models.Asset
        if err := db.Select(&assets, "SELECT * FROM assets WHERE place_id = $1 ORDER BY position", id); err != nil {
            assets = []models.Asset{}
        }

        if assets == nil {
            assets = []models.Asset{}
        }
        place.Assets = assets

        c.JSON(http.StatusOK, place)
    }
}


func DeletePlace(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        query := `DELETE FROM places WHERE place_id = $1`

        result, err := db.Exec(query, placeID)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete place", "details": err.Error()})
            return
        }

        rowsAffected, err := result.RowsAffected()
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check deletion", "details": err.Error()})
            return
        }

        if rowsAffected == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Place deleted successfully"})
    }
}