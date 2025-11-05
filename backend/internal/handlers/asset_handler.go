package handlers

import (
	"fmt"
	"net/http"
	"path/filepath"
	"serpa-maps/internal/models"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func UploadPlaceAssets(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeIDStr := c.Param("id")
        placeID, err := strconv.Atoi(placeIDStr)
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid place id"})
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

        uploaded := []string{}

        for _, file := range files {
            ext := strings.ToLower(filepath.Ext(file.Filename))
            assetType := "image"
            if ext == ".mp4" || ext == ".mov" {
                assetType = "video"
            }

            filename := fmt.Sprintf("uploads/%d_%s", time.Now().UnixNano(), file.Filename)
            if err := c.SaveUploadedFile(file, filename); err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "Fehler beim Speichern"})
                return
            }

            var nextPos int
            err = db.Get(&nextPos, `
                SELECT COALESCE(MAX(position), 0) + 1 
                FROM assets 
                WHERE place_id = $1
            `, placeID)
            if err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "DB error during calculation of position"})
                return
            }

            _, err = db.Exec(`
                INSERT INTO assets (place_id, asset_url, asset_type, position)
                VALUES ($1, $2, $3, $4)
            `, placeID, filename, assetType, nextPos)
            if err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "DB error during insertion", "details": err.Error()})
                return
            }

            uploaded = append(uploaded, filename)
        }

        c.JSON(http.StatusOK, gin.H{"uploaded": uploaded})
    }
}


func UpdateAssetPositions(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        var updates []struct {
            AssetID  int `json:"asset_id"`
            Position int `json:"position"`
        }

        if err := c.ShouldBindJSON(&updates); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON payload"})
            return
        }

        tx, err := db.Beginx()
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        for _, u := range updates {
            _, err := tx.Exec(`
                UPDATE assets
                SET position = $1
                WHERE asset_id = $2 AND place_id = $3
            `, u.Position, u.AssetID, placeID)
            if err != nil {
                tx.Rollback()
                c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
                return
            }
        }

        if err := tx.Commit(); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Positions updated"})
    }
}

func DeletePlaceAsset(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        assetID := c.Param("id")

        var asset models.Asset
        err := db.Get(&asset, "SELECT * FROM assets WHERE asset_id = $1", assetID)
        if err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "Asset not found"})
            return
        }

        _, err = db.Exec("DELETE FROM assets WHERE asset_id = $1", assetID)
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete asset", "details": err.Error()})
            return
        }

        _, err = db.Exec(
            "UPDATE assets SET position = position - 1 WHERE place_id = $1 AND position > $2",
            asset.PlaceID, asset.Position,
        )
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update asset positions", "details": err.Error()})
            return
        }

        c.JSON(http.StatusOK, gin.H{"message": "Asset deleted successfully"})
    }
}