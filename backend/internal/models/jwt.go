package models

type JwtSecrets struct {
	AccessSecret  string
	RefreshSecret string
}

type JwtKeys struct {
	AccessKey  []byte
	RefreshKey []byte
}