package utils

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
)

func ReadFile(root, file string) (*csv.Reader, error) {
	path := filepath.Join(root, file)
	f, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("error opening places file: %v", err)
	}
	defer f.Close()

	r := csv.NewReader(f)
	return r, nil
}