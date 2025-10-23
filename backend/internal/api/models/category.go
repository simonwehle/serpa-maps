package models

import (
	"github.com/google/uuid"
)

type Category struct {
	CategoryID  uuid.UUID `json:"category_id"`
	Name        string    `json:"name"`
	Icon        string    `json:"icon"`
	Color       string    `json:"color"`
}