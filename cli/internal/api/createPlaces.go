package api

import (
	"fmt"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func CreatePlaces(fullUrl string, matchedPlaces []types.Place, accessToken string) ([]types.Place, error) {
	createdPlaces := make([]types.Place, 0, len(matchedPlaces))

	queryUrl := fmt.Sprintf("%s/place", fullUrl)

	for _, place := range matchedPlaces {
		payload := types.CreatePlaceRequest{
			Name:        place.Name,
			Description: place.Description,
			Latitude:    place.Latitude,
			Longitude:   place.Longitude,
			CategoryID:  place.CategoryID,
		}

		createdPlace, err := utils.DoPostRequest[types.Place](queryUrl, payload, accessToken)
		if err != nil {
			return nil, fmt.Errorf("Error during post request: %w", err)
		}

		createdPlaces = append(createdPlaces, *createdPlace)
	}

	return createdPlaces, nil
}

