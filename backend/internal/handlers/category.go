package handlers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"

	"serpa-maps/internal/models"
)

func AddCategory(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var category models.Category

		if err := c.ShouldBindJSON(&category); err != nil {
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
		category.UserID = parsedUserID

		if err := db.Create(&category).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert category", "details": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, category)
	}
}

func GetCategories(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var categories []models.Category

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

		if err = db.Where("user_id = ?", parsedUserID).Order("category_id").Find(&categories).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, categories)
	}
}

func UpdateCategory(db *gorm.DB) gin.HandlerFunc {
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

		var existingCategory models.Category
		if err = db.Where("category_id = ? AND user_id = ?", id, parsedUserID).First(&existingCategory).Error; err != nil {
			if err == gorm.ErrRecordNotFound {
				c.JSON(http.StatusNotFound, gin.H{"error": "Category not found or you don't have permission"})
			} else {
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			}
			return
		}

		if err := db.Model(&models.Category{}).Where("category_id = ? AND user_id = ?", id, parsedUserID).Updates(payload).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update category", "details": err.Error()})
			return
		}

		var category models.Category
		if err := db.Where("category_id = ?", id).First(&category).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Category not found"})
			return
		}

		c.JSON(http.StatusOK, category)
	}
}

func DeleteCategory(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        categoryID := c.Param("id")

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

        result := db.Delete(&models.Category{}, "category_id = ? AND user_id = ?", categoryID, parsedUserID)
        if result.Error != nil {
            c.JSON(http.StatusInternalServerError, gin.H{
                "error":   "Failed to delete category",
                "details": result.Error.Error(),
            })
            return
        }

        if result.RowsAffected == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Category not found or you don't have permission"})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Category deleted successfully"})
    }
}

