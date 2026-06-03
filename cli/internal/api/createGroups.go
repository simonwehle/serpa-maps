package api

import (
	"fmt"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func CreateGroups(fullUrl string, csvGroups []types.Group, accessToken string) ([]types.Group, error) {
    createdGroups := make([]types.Group, 0, len(csvGroups))
    queryUrl := fmt.Sprintf("%s/group", fullUrl)

    for _, category := range csvGroups {
        payload := types.CreateGroupRequest{
            Name:        category.Name,
            Description: category.Description,
        }

        createdGroup, err := utils.DoPostRequest[types.Group](queryUrl, payload, accessToken)
        if err != nil {
            return nil, fmt.Errorf("Error during post request: %w", err)
        }
        createdGroups = append(createdGroups, *createdGroup)
    }

    return createdGroups, nil
}