package cmd

import (
	"flag"
	"fmt"
	"os"

	"serpa-cli/internal/api"
	"serpa-cli/internal/files"
	"serpa-cli/internal/utils"
)

const toolName = "serpa-cli"
const version = "0.5.1"

func Execute() {
	baseUrl := flag.String("u", "", "Serpa Maps base url")
	apiVersion := flag.String("a", "/api/v1", "API version")
	accessToken := flag.String("t", "", "Access Token")
	showHelp := flag.Bool("h", false, "Show this help message")
	showVersion := flag.Bool("v", false, "Show version")

	categoriesFile := "categories.csv"
	placesFile := "places.csv"

	if len(os.Args) == 1 {
		utils.PrintVersion(toolName, version)
		fmt.Fprintln(os.Stdout)
		utils.PrintHelp(toolName)
		os.Exit(0)
	}

	flag.Parse()

	if *showHelp {
		utils.PrintHelp(toolName)
		return
	}

	if *showVersion {
		utils.PrintVersion(toolName, version)
		return
	}

	if *baseUrl == "" {
		fmt.Fprintln(os.Stderr, "Error: Serpa Maps server base url must be not empty; set it using -u (base-url)")
		os.Exit(1)
	}

	if *accessToken == "" {
		fmt.Fprintln(os.Stderr, "Error: Access token must be not empty: set it using -t (access token)")
	}

	var (
		imagesExist = false
	)

	utils.FileExistsOrExit(categoriesFile)
	utils.FileExistsOrExit(placesFile)
	fmt.Println("Files categories.csv and places.csv exist; scanning for images ...")

	root := "."
	folders, images, err := files.CountFoldersAndImages(root)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	if images != 0 {
		fmt.Printf("%d images in %d folders found\n", images, folders)
		imagesExist = true
	} else {
		fmt.Println("No images found; skipping upload assets step")
	}

	csvCategories, err := files.ReadCategoriesCSV(root, categoriesFile)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

	csvPlaces, err := files.ReadPlacesCSV(root, placesFile)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

	assets, err := files.ReadAssets(root)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

	categoriesDefined, err := utils.CategoriesDefined(csvCategories, csvPlaces)
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}

	fullUrl := *baseUrl + *apiVersion
	if categoriesDefined {
		apiCategories, err := api.CreateCategories(fullUrl, csvCategories, *accessToken)
		if err != nil {
			fmt.Println("Error during add categories api call:", err)
		}
		matchedPlaces := utils.MatchPlaces(apiCategories, csvPlaces)

		apiPlaces, err := api.CreatePlaces(fullUrl, matchedPlaces, *accessToken)
		if err != nil {
			fmt.Println("Error during add places api call:", err)
		}
		if imagesExist {
			matchedAssets := utils.MatchAssets(apiPlaces, assets)

			if len(matchedAssets) > 0 {
				err := api.AddAssets(fullUrl, matchedAssets, *accessToken)
				if err != nil {
					fmt.Println("Error during add assets api call:", err)
				}
			} else {
				fmt.Println("Warning: No assets matched to places")
			}
		}
	}
}
