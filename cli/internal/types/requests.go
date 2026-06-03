package types

type CreateCategoryRequest struct {
	Name  string `json:"name"`
	Icon  string `json:"icon"`
	Color string `json:"color"`
}

type CreateGroupRequest struct {
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
}

type CreatePlaceRequest struct {
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
	CategoryID  string  `json:"category_id"`
	GroupIDs    []string `json:"group_ids,omitempty"`
}