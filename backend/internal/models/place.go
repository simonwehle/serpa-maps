package models

import "time"

// TODO: add UUID later

type Place struct {
	PlaceID     int       `gorm:"column:place_id;primaryKey;autoIncrement" json:"place_id"`
	//UserID      int     `gorm:"column:user_id" json:"user_id"`
	Name        string    `gorm:"column:name;not null" json:"name"`
	Description string    `gorm:"column:description" json:"description"`
	Latitude    float64   `gorm:"column:latitude;not null" json:"latitude"`
	Longitude   float64   `gorm:"column:longitude;not null" json:"longitude"`
	CategoryID  int       `gorm:"column:category_id" json:"category_id"`
	CreatedAt   time.Time `gorm:"column:created_at;autoCreateTime" json:"created_at"`
	Assets      []Asset   `gorm:"foreignKey:PlaceID" json:"assets"`
}

func (Place) TableName() string {
	return "places"
}