package files

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	"serpa-cli/internal/types"
)

func ReadGroupCSV(root, groupFile string) ([]types.Group, error) {
    path := filepath.Join(root, groupFile)
    f, err := os.Open(path)
    if err != nil {
        return nil, fmt.Errorf("error opening group file: %v", err)
    }
    defer f.Close()

    r := csv.NewReader(f)

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
        }

        groups = append(groups, group)
    }

    return groups, nil
}