package handlers

import (
	"net/http"

	"serpa-maps/internal/types"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func AddPlace(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var place types.Place

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
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert category", "details": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, place)
	}
}

func GetPlaces(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var places []types.Place

		if err := db.Select(&places, "SELECT * FROM places ORDER BY place_id"); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, places)
	}
}
