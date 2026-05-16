package files

import (
	"os"
	"path/filepath"
	"strings"
)

func isImageFile(filename string) bool {
    ext := strings.ToLower(filepath.Ext(filename))
    switch ext {
    case ".jpg", ".jpeg", ".png", ".gif", ".bmp":
        return true
    }
	return false
}

func CountFoldersAndImages(root string) (int, int, error) {
	var folderCount, imageCount int
	err := filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if path == root {
			return nil
		}
		if info.IsDir() {
			folderCount++
		} else if isImageFile(info.Name()) {
			imageCount++
		}
		return nil
	})
	return folderCount, imageCount, err
}