package models

import (
	"github.com/google/uuid"
)

type Category struct {
	CategoryID  uuid.UUID `gorm:"primaryKey;type:uuid;default:gen_random_uuid()" json:"category_id"`
	Name        string    `json:"name"`
	Icon        string    `json:"icon"`
	Color       string    `json:"color"`
}