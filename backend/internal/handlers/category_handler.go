package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"

	"serpa-maps/internal/types"
)

func AddCategory(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var category types.Category

		if err := c.ShouldBindJSON(&category); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
			return
		}

		query := `
			INSERT INTO categories (name, icon, color)
			VALUES ($1, $2, $3)
			RETURNING category_id;
		`

		err := db.QueryRow(query, category.Name, category.Icon, category.Color).
			Scan(&category.CategoryID)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert category", "details": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, category)
	}
}

func GetCategories(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var categories []types.Category

		if err := db.Select(&categories, "SELECT * FROM categories ORDER BY category_id"); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, categories)
	}
}
