package files

import (
	"fmt"
	"io"
	"strings"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func ReadCategoriesCSV(root, categoriesFile string) ([]types.Category, error) {
    r, err := utils.ReadFile(root, categoriesFile)

    header, err := r.Read()
    if err != nil {
        return nil, fmt.Errorf("error reading header from categories file: %v", err)
    }

    colIndex := make(map[string]int)
    for i, colName := range header {
        colIndex[strings.ToLower(strings.TrimSpace(colName))] = i
    }

    requiredCols := []string{"name", "icon", "color"}
    for _, c := range requiredCols {
        if _, ok := colIndex[c]; !ok {
            return nil, fmt.Errorf("categories file missing required column '%s'", c)
        }
    }

    var categories []types.Category
    for {
        record, err := r.Read()
        if err == io.EOF {
            break
        }
        if err != nil {
            return nil, fmt.Errorf("error reading categories file: %v", err)
        }

        category := types.Category{
            Name:  strings.TrimSpace(record[colIndex["name"]]),
            Icon:  strings.TrimSpace(record[colIndex["icon"]]),
            Color: strings.TrimSpace(record[colIndex["color"]]),
        }

        categories = append(categories, category)
    }

    return categories, nil
}
