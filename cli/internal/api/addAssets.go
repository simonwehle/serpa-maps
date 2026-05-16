package api

import (
	"bytes"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func AddAssets(fullUrl string, matchedAssets []types.PlaceAssets, accessToken string) error {
	client := &http.Client{}

	for _, placeAssets := range matchedAssets {
		uploadUrl := fmt.Sprintf("%s/place/%s/assets", fullUrl, placeAssets.PlaceID)

		body := &bytes.Buffer{}
		writer := multipart.NewWriter(body)

		for _, assetPath := range placeAssets.Assets {
			file, err := os.Open(assetPath)
			if err != nil {
				return fmt.Errorf("failed to open file %s: %w", assetPath, err)
			}

			part, err := writer.CreateFormFile("assets", filepath.Base(assetPath))
			if err != nil {
				file.Close()
				return fmt.Errorf("failed to create form file for %s: %w", assetPath, err)
			}

			_, err = io.Copy(part, file)
			file.Close()
			if err != nil {
				return fmt.Errorf("failed to copy file data for %s: %w", assetPath, err)
			}
		}

		err := writer.Close()
		if err != nil {
			return fmt.Errorf("failed to close multipart writer: %w", err)
		}

		req, err := http.NewRequest("POST", uploadUrl, body)
		if err != nil {
			return fmt.Errorf("failed to create POST request: %w", err)
		}
		req.Header.Set("Content-Type", writer.FormDataContentType())
		utils.SetBearerAuth(req, accessToken)

		resp, err := client.Do(req)
		if err != nil {
			return fmt.Errorf("POST request failed: %w", err)
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return fmt.Errorf("upload failed for place %s: status %s", placeAssets.PlaceID, resp.Status)
		}

		fmt.Printf("Uploaded %d assets for place ID %s successfully\n", len(placeAssets.Assets), placeAssets.PlaceID)
	}

	return nil
}
