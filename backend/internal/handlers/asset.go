package handlers

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"serpa-maps/internal/models"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func UploadPlaceAssets(db *gorm.DB, mediaStorageDir string) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeIDStr := c.Param("id")
        placeID, err := uuid.Parse(placeIDStr)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place id"})
            return
        }

		var count int64
		if err := db.Model(&models.Place{}).Where("place_id = ?", placeID).Count(&count).Error; err != nil || count == 0 {
			c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
			return
		}

        form, err := c.MultipartForm()
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Error reading uploaded files"})
            return
        }

        files := form.File["assets"]
        if len(files) == 0 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "No file uploaded"})
            return
        }

		const maxFileSize = 10 * 1024 * 1024
		for _, file := range files {
			if file.Size > maxFileSize {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("File %s exceeds 10MB limit", file.Filename)})
				return
			}
		}

        if err := os.MkdirAll(mediaStorageDir, 0o755); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while preparing asset directory"})
            return
        }

        uploadedAssets := []models.Asset{}

        for _, file := range files {
            ext := strings.ToLower(filepath.Ext(file.Filename))
			
			validExtensions := map[string]bool{
				".jpg": true, ".jpeg": true, ".png": true, ".gif": true,
				".mp4": true, ".mov": true, ".webp": true,
			}
			if !validExtensions[ext] {
				c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Invalid file type: %s", ext)})
				return
			}


            assetFilename := fmt.Sprintf("%s%s", uuid.Must(uuid.NewV7()).String(), ext)
            storagePath := filepath.Join(mediaStorageDir, assetFilename)
            if err := c.SaveUploadedFile(file, storagePath); err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while saving asset"})
                return
            }
            if err := os.Chmod(storagePath, 0o644); err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Error while setting asset permissions"})
                return
            }

            var nextPos int
            if err := db.Model(&models.Asset{}).Where("place_id = ?", placeID).Select("COALESCE(MAX(position), 0) + 1").Scan(&nextPos).Error; err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "DB error during calculation of position"})
                return
            }

            assetType := "image"
            if ext == ".mp4" || ext == ".mov" {
                assetType = "video"
            }

            newAsset := models.Asset{
                PlaceID:   placeID,
                AssetFilename:  assetFilename,
                AssetType: assetType,
                Position:  nextPos,
            }

            if err := db.Create(&newAsset).Error; err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "DB error during insertion", "details": err.Error()})
                return
            }

            uploadedAssets = append(uploadedAssets, newAsset)
        }

        c.JSON(http.StatusOK, gin.H{"assets": uploadedAssets})
    }
}


func UpdateAssetPositions(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        var updates []struct {
            AssetID  uuid.UUID `json:"asset_id"`
            Position int       `json:"position"`
        }

        if err := c.ShouldBindJSON(&updates); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        err := db.Transaction(func(tx *gorm.DB) error {
            for _, u := range updates {
                if err := tx.Model(&models.Asset{}).
                    Where("asset_id = ? AND place_id = ?", u.AssetID, placeID).
                    Update("position", u.Position).Error; err != nil {
                    return err
                }
            }
            return nil
        })

        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Positions updated"})
    }
}

func ServeAsset(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        filename := c.Param("filename")

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

        var asset models.Asset
        var place models.Place
        if err := db.Where("asset_filename = ?", filename).First(&asset).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Asset not found"})
            return
        }
        if err := db.Where("place_id = ? AND user_id = ?", asset.PlaceID, parsedUserID).First(&place).Error; err != nil {
            c.JSON(http.StatusForbidden, gin.H{"error": "You do not have access to this asset"})
            return
        }

        c.Header("X-Accel-Redirect", "/protected-assets/"+asset.AssetFilename)
        c.Status(http.StatusOK)
    }
}

func DeletePlaceAsset(db *gorm.DB, mediaStorageDir string) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeIDStr := c.Param("id")
        assetIDStr := c.Param("asset_id")
        
        placeID, err := uuid.Parse(placeIDStr)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place id"})
            return
        }
        
        assetID, err := uuid.Parse(assetIDStr)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid asset id"})
            return
        }

        var count int64
        if err := db.Model(&models.Place{}).Where("place_id = ?", placeID).Count(&count).Error; err != nil || count == 0 {
            c.JSON(http.StatusNotFound, gin.H{"error": "Place not found"})
            return
        }

        var asset models.Asset
        if err := db.Select("asset_filename, position").
            Where("asset_id = ? AND place_id = ?", assetID, placeID).
            First(&asset).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Asset not found"})
            return
        }

        if err := db.Delete(&models.Asset{}, "asset_id = ? AND place_id = ?", assetID, placeID).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "DB error during deletion"})
            return
        }

        filePath := filepath.Join(mediaStorageDir, asset.AssetFilename)
        if err := os.Remove(filePath); err != nil {
            log.Printf("Failed to delete file %s: %v", filePath, err)
        }

        if err := db.Model(&models.Asset{}).
            Where("place_id = ? AND position > ?", placeID, asset.Position).
            UpdateColumn("position", gorm.Expr("position - 1")).Error; err != nil {
            log.Printf("Failed to reorder assets: %v", err)
        }

        c.JSON(http.StatusOK, gin.H{"message": "Asset deleted successfully"})
    }
}
