# serpa-cli

CLI tool to upload categories, places and assets to the serpa maps backend

## usage:

The files `categories.csv`, `groups.csv` and `places.csv` must exist. In order to add assets to a place they should be in a folder with the exact place name. The order in which categories and places are added is defined by their position in the csv. The first column is added first. Same applies for assets inside a folder.

```
folder/
├── categories.csv
├── groups.csv
├── places.csv
└── Null Island
    ├── first_image.jpg
    └── second_image.png
```

`categories.csv` should contain the following columns

```csv
name,icon,color
landmark,camera_alt,#9c27b0
```

`groups.csv` should container the following columns (description can be empty)

```csv
name,description
example,
```

`places.csv` should contain the following columns (description can be empty and group is optional)

```csv
latitude,longitude,name,description,category,group
0,0,Null Island,,landmark,example
-48.876667,-123.393333,Point Nemo,The place in the ocean that is farthest from land,landmark
```

Now navigate to the folder via the terminal and set base-url and access token as parameters

```sh
serpa-cli -u <serpa-maps server base url> -t <access token> (-a <api version>)
```

Examples:

```sh
serpa-cli -u http://localhost:53164 -t eyJhbGciOiJIUz...
serpa-cli -u http://localhost:53164 -t eyJhbGciOiJIUz... -a /api/v1
```

## build

```sh
go build .
sudo mv serpa-cli /usr/local/bin/
```

uninstall

```
sudo rm /usr/local/bin/serpa-cli
```
