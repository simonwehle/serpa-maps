package utils

import (
	"fmt"

	"serpa-cli/internal/types"
)

func GroupsDefined(csvGroups []types.Group, csvPlaces []types.Place) (bool, error) {
	groupMap := make(map[string]string)
	for _, group := range csvGroups {
		groupMap[group.Name] = group.GroupID
	}

	for i := range csvPlaces {
		groupName := csvPlaces[i].GroupName
		id, ok := groupMap[groupName]
		if !ok {
			return false, fmt.Errorf("group not found for place '%s': %s", csvPlaces[i].Name, groupName)
		}
		csvPlaces[i].GroupIDs = []string{id}
	}
	return true, nil
}