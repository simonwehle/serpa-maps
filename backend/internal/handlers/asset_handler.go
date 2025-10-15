package handlers

import (
	"fmt"
	"net/http"
	"path/filepath"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

func UploadPlaceAssets(db *sqlx.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        placeID := c.Param("id")

        form, err := c.MultipartForm()
        if err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Fehler beim Lesen des Uploads"})
            return
        }

        files := form.File["assets"]
        if len(files) == 0 {
            c.JSON(http.StatusBadRequest, gin.H{"error": "Keine Dateien hochgeladen"})
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

            _, err = db.Exec(`
                INSERT INTO place_assets (place_id, asset_url, asset_type)
                VALUES ($1, $2, $3)
            `, placeID, filename, assetType)
            if err != nil {
                c.JSON(http.StatusInternalServerError, gin.H{"error": "DB-Fehler", "details": err.Error()})
                return
            }

            uploaded = append(uploaded, filename)
        }

        c.JSON(http.StatusOK, gin.H{
            "message":    "Assets erfolgreich hochgeladen",
            "asset_urls": uploaded,
        })
    }
}
