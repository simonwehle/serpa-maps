package models

// TODO: add UUID later

type Category struct {
	CategoryID  int    `db:"category_id" json:"category_id"`
	Name        string `db:"name" json:"name"`
	Icon        string `db:"icon" json:"icon"`
	Color       string `db:"color" json:"color"`
}