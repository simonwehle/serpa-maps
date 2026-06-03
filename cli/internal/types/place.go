package types

type Place struct {
	PlaceID      string  `json:"place_id"`
	Name         string  `json:"name"`
	Description  string  `json:"description"`
	Latitude     float64 `json:"latitude"`
	Longitude    float64 `json:"longitude"`
	CategoryID   string  `json:"category_id"`
	CategoryName string
	GroupIDs     []string `json:"group_ids"`
	GroupID      string   `json:"-"`
	GroupName    string
}