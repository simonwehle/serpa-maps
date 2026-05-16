package utils

import (
	"fmt"

	"serpa-cli/internal/types"
)

func CategoriesDefined(csvCategories []types.Category, csvPlaces []types.Place) (bool, error) {
	categoryMap := make(map[string]string)
	for _, category := range csvCategories {
		categoryMap[category.Name] = category.CategoryID
	}

	for i := range csvPlaces {
		categoryName := csvPlaces[i].CategoryName
		id, ok := categoryMap[categoryName]
		if !ok {
			return false, fmt.Errorf("category not found for place '%s': %s", csvPlaces[i].Name, categoryName)
		}
		csvPlaces[i].CategoryID = id
	}
	return true, nil
}