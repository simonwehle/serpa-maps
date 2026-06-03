package files

import (
	"fmt"
	"io"
	"strings"

	"serpa-cli/internal/types"
	"serpa-cli/internal/utils"
)

func ReadGroupCSV(root, groupFile string) ([]types.Group, error) {
    r, f, err := utils.ReadFile(root, groupFile)
    if err != nil {
        return nil, fmt.Errorf("read group csv: %v", err)
    }
    defer f.Close()

    header, err := r.Read()
    if err != nil {
        return nil, fmt.Errorf("error reading header from group file: %v", err)
    }

    colIndex := make(map[string]int)
    for i, colName := range header {
        colIndex[strings.ToLower(strings.TrimSpace(colName))] = i
    }

    requiredCols := []string{"name"}
    for _, c := range requiredCols {
        if _, ok := colIndex[c]; !ok {
            return nil, fmt.Errorf("group file missing required column '%s'", c)
        }
    }

    var groups []types.Group
    for {
        record, err := r.Read()
        if err == io.EOF {
            break
        }
        if err != nil {
            return nil, fmt.Errorf("error reading group file: %v", err)
        }

        group := types.Group{
            Name:  strings.TrimSpace(record[colIndex["name"]]),
            Description: strings.TrimSpace(record[colIndex["description"]]),
        }

        groups = append(groups, group)
    }

    return groups, nil
}