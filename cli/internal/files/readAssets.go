package files

import (
	"io/fs"
	"path/filepath"

	"serpa-cli/internal/types"
)

func ReadAssets(root string) ([]types.PlaceAssets, error) {
    placeMap := make(map[string]*types.PlaceAssets)

    err := filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
        if err != nil {
            return err
        }
        if d.IsDir() {
            return nil
        }

        if !isImageFile(d.Name()) {
            return nil
        }

        folder := filepath.Base(filepath.Dir(path))

        if _, exists := placeMap[folder]; !exists {
            placeMap[folder] = &types.PlaceAssets{
                PlaceName: folder,
                Assets:    []string{},
            }
        }

        placeMap[folder].Assets = append(placeMap[folder].Assets, path)
        return nil
    })
    if err != nil {
        return nil, err
    }

    places := make([]types.PlaceAssets, 0, len(placeMap))
    for _, place := range placeMap {
        places = append(places, *place)
    }
    return places, nil
}