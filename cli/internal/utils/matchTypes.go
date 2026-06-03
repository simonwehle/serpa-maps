package utils

import (
	"serpa-cli/internal/types"
	"strings"
)

func MatchCategoriesToPlaces(apiCategories []types.Category, csvPlaces []types.Place) []types.Place {
	for i, place := range csvPlaces {
		for _, category := range apiCategories {
			if category.Name == place.CategoryName {
				csvPlaces[i].CategoryID = category.CategoryID
				break
			}
		}
	}
	return csvPlaces
}

func MatchGroupsToPlaces(apiGroups []types.Group, csvPlaces []types.Place) []types.Place {
	for i, place := range csvPlaces {
		for _, group := range apiGroups {
			if group.Name == place.GroupName {
				csvPlaces[i].GroupIDs = []string{group.GroupID}
				// or append: append(csvPlaces[i].GroupIDs, group.GroupID) and remove break
				break
			}
		}
	}
	return csvPlaces
}

func MatchAssets(apiPlaces []types.Place, placeAssets []types.PlaceAssets) []types.PlaceAssets {
	var matchedAssets []types.PlaceAssets
	for _, asset := range placeAssets {
		normalizedAssetPlaceName := normalizeForMatch(asset.PlaceName)
		for _, place := range apiPlaces {
			if normalizeForMatch(place.Name) == normalizedAssetPlaceName {
				asset.PlaceID = place.PlaceID
				matchedAssets = append(matchedAssets, asset)
				break
			}
		}
	}
	return matchedAssets
}

func normalizeForMatch(value string) string {
	normalized := strings.ToLower(strings.TrimSpace(value))
	return strings.NewReplacer(
		"a\u0308", "ä",
		"o\u0308", "ö",
		"u\u0308", "ü",
	).Replace(normalized)
}
