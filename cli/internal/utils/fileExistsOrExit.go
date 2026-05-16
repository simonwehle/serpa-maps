package utils

import (
	"fmt"
	"os"
)

func FileExistsOrExit(file string) {
	if _, err := os.Stat(file); err != nil {
		fmt.Fprintln(os.Stderr, "Error: No", file, "found")
		os.Exit(1)
	} 
}