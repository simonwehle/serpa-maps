package handlers

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"

	"serpa-maps/internal/models"
)

func AddCategory(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var category models.Category

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
		var categories []models.Category

		if err := db.Select(&categories, "SELECT * FROM categories ORDER BY category_id"); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, categories)
	}
}

func UpdateCategory(db *sqlx.DB) gin.HandlerFunc {
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

		query := fmt.Sprintf("UPDATE categories SET %s WHERE category_id = $%d", strings.Join(setClauses, ", "), i)

		if _, err := db.Exec(query, args...); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update category", "details": err.Error()})
			return
		}

		var category models.Category
		if err := db.Get(&category, "SELECT * FROM categories WHERE category_id = $1", id); err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Category not found"})
			return
		}

		c.JSON(http.StatusOK, category)
	}
}

func DeleteCategory(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        categoryID := c.Param("id")

        query := `DELETE FROM categories WHERE category_id = $1`

        result, err := db.Exec(query, categoryID)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{
                "error":   "Failed to delete category",
                "details": err.Error(),
            })
            return
        }

        rowsAffected, err := result.RowsAffected()
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{
                "error":   "Failed to check deletion",
                "details": err.Error(),
            })
            return
        }

        if rowsAffected == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Category not found"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Category deleted successfully"})
    }
}

