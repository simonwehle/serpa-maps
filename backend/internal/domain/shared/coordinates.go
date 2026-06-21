package shared

import "errors"

type Coordinates struct {
	Latitude  float64 `gorm:"column:latitude;not null" json:"latitude"`
	Longitude float64 `gorm:"column:longitude;not null" json:"longitude"`
}

func NewCoordinates(lat, lng float64) (Coordinates, error) {
	if lat < -90 || lat > 90 {
		return Coordinates{}, errors.New("geo: latitude out of range")
	}
	if lng < -180 || lng > 180 {
		return Coordinates{}, errors.New("geo: longitude out of range")
	}
	return Coordinates{Latitude: lat, Longitude: lng}, nil
}

func (c Coordinates) Lat() float64 { return c.Latitude }
func (c Coordinates) Lng() float64 { return c.Longitude }