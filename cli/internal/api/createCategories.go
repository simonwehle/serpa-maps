package api

import (
	"fmt"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func CreateCategories(fullUrl string, csvCategories []types.Category, accessToken string) ([]types.Category, error) {
    createdCategories := make([]types.Category, 0, len(csvCategories))
    queryUrl := fmt.Sprintf("%s/category", fullUrl)

    for _, category := range csvCategories {
        payload := types.CreateCategoryRequest{
            Name:  category.Name,
            Icon:  category.Icon,
            Color: category.Color,
        }

        createdCategory, err := utils.DoPostRequest[types.Category](queryUrl, payload, accessToken)
        if err != nil {
            return nil, fmt.Errorf("Error during post request: %w", err)
        }
        createdCategories = append(createdCategories, *createdCategory)
    }

    return createdCategories, nil
}
