package files

import (
	"fmt"
	"io"
	"strconv"
	"strings"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func ReadPlacesCSV(root, placesFile string) ([]types.Place, error) {
	r, f, err := utils.ReadFile(root, placesFile)
	if err != nil {
		return nil, fmt.Errorf("error reading places csv file: %v", err)
	}
	defer f.Close()

	header, err := r.Read()
	if err != nil {
		return nil, fmt.Errorf("error reading header from places file: %v", err)
	}

	colIndex := make(map[string]int)
	for i, colName := range header {
		colIndex[strings.ToLower(strings.TrimSpace(colName))] = i
	}

	requiredCols := []string{"name", "description", "latitude", "longitude", "category", "group"}
	for _, c := range requiredCols {
		if _, ok := colIndex[c]; !ok {
			return nil, fmt.Errorf("places file missing required column '%s'", c)
		}
	}

	var places []types.Place
	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, fmt.Errorf("error reading places file: %v", err)
		}

		for _, c := range requiredCols {
			if colIndex[c] >= len(record) {
				return nil, fmt.Errorf("places file row missing required column '%s'", c)
			}
		}

		lat, err := strconv.ParseFloat(strings.TrimSpace(record[colIndex["latitude"]]), 64)
		if err != nil {
			return nil, fmt.Errorf("error parsing latitude: %v", err)
		}

		lon, err := strconv.ParseFloat(strings.TrimSpace(record[colIndex["longitude"]]), 64)
		if err != nil {
			return nil, fmt.Errorf("error parsing longitude: %v", err)
		}

		place := types.Place{
			Name:         strings.TrimSpace(record[colIndex["name"]]),
			Description:  strings.TrimSpace(record[colIndex["description"]]),
			Latitude:     lat,
			Longitude:    lon,
			CategoryName: strings.TrimSpace(record[colIndex["category"]]),
			GroupName: strings.TrimSpace(record[colIndex["group"]]),
		}

		places = append(places, place)
	}

	return places, nil
}