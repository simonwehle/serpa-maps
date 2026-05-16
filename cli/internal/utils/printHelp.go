package utils

import (
	"fmt"
)

func PrintHelp(toolName string) {
	fmt.Printf("Usage:\n")
	fmt.Printf("  %s -u <serpa-maps server base url> -t <access token> (-a <api version>)\n\n", toolName)

	fmt.Println("Example:")
	fmt.Printf("  %s -u http://localhost:53164 -t eyJhbGciOiJIUz...\n", toolName)
	fmt.Printf("  %s -u http://localhost:53164 -t eyJhbGciOiJIUz... -a /api/v1\n", toolName)
}

func PrintVersion(toolName, version string) {
	fmt.Printf("%s version %s\n", toolName, version)
}
