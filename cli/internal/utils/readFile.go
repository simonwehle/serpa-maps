package utils

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
)

func ReadFile(root, file string) (*csv.Reader, *os.File, error) {
	path := filepath.Join(root, file)
	f, err := os.Open(path)
	if err != nil {
		return nil, nil, fmt.Errorf("error opening %s: %v", file, err)
	}

	r := csv.NewReader(f)
	return r, f, nil
}